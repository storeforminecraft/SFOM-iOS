//
//  Post.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import Foundation

struct Post: Decodable {
    var id: String
    var authorUid: String
    var basedLanguage: String
    var boardId: String
    var body: PostBody?
    var bodyType: String
    var coverImage: String?
    var createdTimestamp: Date?
    var modifiedTimestamp: Date?
    var state: String
    var tags: [String]?
    var title: String
    var translatedBodies: [String: PostBody]
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.authorUid = try container.decode(String.self, forKey: .authorUid)
        self.basedLanguage = try container.decode(String.self, forKey: .basedLanguage)
        self.boardId = try container.decode(String.self, forKey: .boardId)

        let bodyString = try container.decode(String.self, forKey: .body)
        self.body = try? JSONDecoder().decode(PostBody.self, from: bodyString.data(using: .utf8)!)

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

        self.translatedBodies = translatedBodies.reduce(into: [String: PostBody]()) { partialResult, dict in
            partialResult[dict.key] = try? JSONDecoder().decode(PostBody.self, from: dict.value.data(using: .utf8)!)
        }
        
        self.translatedTitles = try container.decode([String: String].self, forKey: .translatedTitles)
    }
}

struct PostBody: Decodable {
    var format: String
    var version: Int
    var body: [PostBodyContent]
}

struct PostBodyContent: Decodable {
    var type: String
    var data: String
}

