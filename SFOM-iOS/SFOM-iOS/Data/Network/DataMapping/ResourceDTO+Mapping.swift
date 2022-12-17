//
//  ResourceDTO+Mapping.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Foundation

struct ResourceDTO: Codable {
    let authorUid: String
    let basedLanguage: String
    let category: SFOMCategory
    let chidCommentsCount: Int?
    let createdTimestamp: Date
    let desc: String
    let downloadCount: Int
    let fileExt: String
    let fileHash: String
    let id: String
    let images: [String]
    let likeCount: Int
    let name: String
    let modifiedTimestamp: Date
    let state: String
    let tags: [String]
    let translatedDescs: [String: String]
    let translatedNames: [String: String]
    let translationSource: String
    let version: Int
    
    init(authorUid: String,
         basedLanguage: String,
         category: SFOMCategory,
         chidCommentsCount: Int?,
         createdTimestamp: Date,
         desc: String,
         downloadCount: Int,
         fileExt: String,
         fileHash: String,
         id: String,
         images: [String],
         likeCount: Int,
         name: String,
         modifiedTimestamp: Date,
         state: String,
         tags: [String],
         translatedDescs: [String: String],
         translatedNames: [String: String],
         translationSource: String,
         version: Int) {
        self.authorUid = authorUid
        self.basedLanguage = basedLanguage
        self.category = category
        self.chidCommentsCount = chidCommentsCount
        self.createdTimestamp = createdTimestamp
        self.desc = desc
        self.downloadCount = downloadCount
        self.fileExt = fileExt
        self.fileHash = fileHash
        self.id = id
        self.images = images
        self.likeCount = likeCount
        self.name = name
        self.modifiedTimestamp = modifiedTimestamp
        self.state = state
        self.tags = tags
        self.translatedDescs = translatedDescs
        self.translatedNames = translatedNames
        self.translationSource = translationSource
        self.version = version
    }
    
    enum CodingKeys: CodingKey {
        case authorUid, basedLanguage, desc, fileExt, fileHash, id, name, state
        case createdTimestamp, modifiedTimestamp
        case chidCommentsCount, downloadCount, likeCount
        case images, tags
        case translatedDescs, translatedNames, translationSource
        case version
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authorUid = try container.decode(String.self, forKey: .authorUid)
        self.basedLanguage = try container.decode(String.self, forKey: .basedLanguage)
        
        let categoryStr = try container.decode(String.self, forKey: .category)
        self.category = SFOMCategory(rawValue: categoryStr.lowercased()) ?? .unknown
        
        self.chidCommentsCount = try container.decodeIfPresent(Int.self, forKey: .chidCommentsCount)
        self.createdTimestamp = try container.decode(Date.self, forKey: .createdTimestamp)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.downloadCount = try container.decode(Int.self, forKey: .downloadCount)
        self.fileExt = try container.decode(String.self, forKey: .fileExt)
        self.fileHash = try container.decode(String.self, forKey: .fileHash)
        self.id = try container.decode(String.self, forKey: .id)
        self.images = try container.decode([String].self, forKey: .images)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.name = try container.decode(String.self, forKey: .name)
        self.modifiedTimestamp = try container.decode(Date.self, forKey: .modifiedTimestamp)
        self.state = try container.decode(String.self, forKey: .state)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.translatedDescs = try container.decode([String: String].self, forKey: .translatedDescs)
        self.translatedNames = try container.decode([String: String].self, forKey: .translatedNames)
        self.translationSource = try container.decode(String.self, forKey: .translationSource)
        self.version = try container.decode(Int.self, forKey: .version)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(authorUid, forKey: .authorUid)
        try container.encode(basedLanguage, forKey: .basedLanguage)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(chidCommentsCount, forKey: .chidCommentsCount)
        try container.encode(createdTimestamp, forKey: .createdTimestamp)
        try container.encode(desc, forKey: .desc)
        try container.encode(downloadCount, forKey: .downloadCount)
        try container.encode(fileExt, forKey: .fileExt)
        try container.encode(fileHash, forKey: .fileHash)
        try container.encode(id, forKey: .id)
        try container.encode(images, forKey: .images)
        try container.encode(likeCount, forKey: .likeCount)
        try container.encode(name, forKey: .name)
        try container.encode(modifiedTimestamp, forKey: .modifiedTimestamp)
        try container.encode(state, forKey: .state)
        try container.encode(tags, forKey: .tags)
        try container.encode(translatedDescs, forKey: .translatedDescs)
        try container.encode(translatedNames, forKey: .translatedNames)
        try container.encode(translationSource, forKey: .translationSource)
        try container.encode(version, forKey: .version)
    }
}

extension ResourceDTO {
    func toDomain() -> Resource {
        return Resource(authorUid: authorUid,
                        basedLanguage: basedLanguage,
                        category: category,
                        chidCommentsCount: chidCommentsCount,
                        createdTimestamp: createdTimestamp,
                        desc: desc,
                        downloadCount: downloadCount,
                        fileExt: fileExt,
                        fileHash: fileHash,
                        id: id,
                        images:images,
                        likeCount: likeCount,
                        name: name,
                        modifiedTimestamp: modifiedTimestamp,
                        state: state,
                        tags: tags,
                        translatedDescs: translatedDescs,
                        translatedNames: translatedNames,
                        translationSource: translationSource,
                        version: version)
    }
}
