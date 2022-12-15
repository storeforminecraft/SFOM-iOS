//
//  PostDTO+Mapping.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/12.
//

import Foundation

struct PostDTO: Decodable {
    var id: String
    var authorUid: String
    var basedLanguage: String
    var boardId: String
    var body: PostBodyDTO?
    var bodyType: String
    var coverImage: String?
    var createdTimestamp: Date?
    var modifiedTimestamp: Date?
    var state: String
    var tags: [String]?
    var title: String
    var translatedBodies: [String: PostBodyDTO]
    var translatedTitles: [String: String]
    
    enum CodingKeys: CodingKey {
        case id
        case authorUid
        case basedLanguage
        case boardId
        case body
        case bodyType
        case coverImage
        case createdTimestamp
        case modifiedTimestamp
        case state
        case tags
        case title
        case translatedBodies
        case translatedTitles
    }
    
    init(id: String,
         authorUid: String,
         basedLanguage: String,
         boardId: String,
         body: PostBodyDTO? = nil,
         bodyType: String,
         coverImage: String? = nil,
         createdTimestamp: Date? = nil,
         modifiedTimestamp: Date? = nil,
         state: String,
         tags: [String]? = nil,
         title: String,
         translatedBodies: [String : PostBodyDTO],
         translatedTitles: [String : String]) {
        self.id = id
        self.authorUid = authorUid
        self.basedLanguage = basedLanguage
        self.boardId = boardId
        self.body = body
        self.bodyType = bodyType
        self.coverImage = coverImage
        self.createdTimestamp = createdTimestamp
        self.modifiedTimestamp = modifiedTimestamp
        self.state = state
        self.tags = tags
        self.title = title
        self.translatedBodies = translatedBodies
        self.translatedTitles = translatedTitles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.authorUid = try container.decode(String.self, forKey: .authorUid)
        self.basedLanguage = try container.decode(String.self, forKey: .basedLanguage)
        self.boardId = try container.decode(String.self, forKey: .boardId)
        
        let bodyString = try container.decode(String.self, forKey: .body)
        self.body = try? JSONDecoder().decode(PostBodyDTO.self, from: bodyString.data(using: .utf8)!)
        
        self.bodyType = try container.decode(String.self, forKey: .bodyType)
        
        if let coverImage = try container.decodeIfPresent(String.self, forKey: .coverImage) {
            self.coverImage = "https://image.storeforminecraft.dev/" + coverImage
        }
        
        self.createdTimestamp = try container.decodeIfPresent(Date.self, forKey: .createdTimestamp)
        self.modifiedTimestamp = try container.decodeIfPresent(Date.self, forKey: .modifiedTimestamp)
        self.state = try container.decode(String.self, forKey: .state)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags)
        self.title = try container.decode(String.self, forKey: .title)
        let translatedBodies = try container.decode([String: String].self, forKey: .translatedBodies)
        
        self.translatedBodies = translatedBodies.reduce(into: [String: PostBodyDTO]()) { partialResult, dict in
            partialResult[dict.key] = try? JSONDecoder().decode(PostBodyDTO.self, from: dict.value.data(using: .utf8)!)
        }
        
        self.translatedTitles = try container.decode([String: String].self, forKey: .translatedTitles)
    }
}

struct PostBodyDTO: Decodable {
    var format: String
    var version: Int
    var body: [PostBodyContentDTO]
    
    init(format: String, version: Int, body: [PostBodyContentDTO]) {
        self.format = format
        self.version = version
        self.body = body
    }
}

struct PostBodyContentDTO: Decodable {
    var type: String
    var data: String
    
    enum CodingKeys: CodingKey {
        case type
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.data = try container.decode(String.self, forKey: .data)
    }
}


extension PostDTO {
    func toDomain() -> Post {
        return Post(id: id,
                    authorUid: authorUid,
                    basedLanguage: basedLanguage,
                    boardId: boardId,
                    body: body?.toDomain(),
                    bodyType: bodyType,
                    coverImage: coverImage,
                    createdTimestamp: createdTimestamp,
                    modifiedTimestamp: modifiedTimestamp,
                    state: state,
                    tags: tags,
                    title: title,
                    translatedBodies: translatedBodies.compactMapValues{ $0.toDomain() },
                    translatedTitles: translatedTitles)
    }
}

extension PostBodyDTO {
    func toDomain() -> PostBody {
        return PostBody(format: format,
                        version: version,
                        body: body.compactMap{ $0.toDomain() })
    }
}

extension PostBodyContentDTO {
    func toDomain() -> PostBodyContent {
        return PostBodyContent(type: type,
                               data: data)
    }
}
