//
//  Post.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import Foundation

struct Post {
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
    
    init(id: String,
         authorUid: String,
         basedLanguage: String,
         boardId: String,
         body: PostBody?,
         bodyType: String,
         coverImage: String?,
         createdTimestamp: Date?,
         modifiedTimestamp: Date?,
         state: String,
         tags: [String]?,
         title: String,
         translatedBodies: [String : PostBody],
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
}

struct PostBody {
    var format: String
    var version: Int
    var body: [PostBodyContent]
    
    init(format: String, version: Int, body: [PostBodyContent]) {
        self.format = format
        self.version = version
        self.body = body
    }
}

struct PostBodyContent {
    var type: String
    var data: String
    
    init(type: String, data: String) {
        self.type = type
        self.data = data
    }
}

