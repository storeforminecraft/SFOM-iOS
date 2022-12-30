//
//  Post.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import Foundation

struct Post {
    let id: String
    let authorUid: String
    let basedLanguage: String
    let boardId: String
    let body: PostBody?
    let bodyType: String
    let coverImage: String?
    let createdTimestamp: Date?
    let modifiedTimestamp: Date?
    let state: String
    let tags: [String]?
    let title: String
    let translatedBodies: [String: PostBody]
    let translatedTitles: [String: String]
    
    var localizedTitle: String {
        let location = StringCollection.location
        if basedLanguage == location {
            return title
        } else {
            return translatedTitles[location] ?? title
        }
    }
    
    var localizedBody: PostBody {
        let location = StringCollection.location
        if basedLanguage == location, let body = body {
            return body
        } else {
            return (translatedBodies[location] ?? body ) ?? PostBody(format: "", version: 0, body: [])
        }
    }
    
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
    let format: String
    let version: Int
    let body: [PostBodyContent]
    
    init(format: String, version: Int, body: [PostBodyContent]) {
        self.format = format
        self.version = version
        self.body = body
    }
}

struct PostBodyContent {
    let type: String
    let data: String
    
    init(type: String, data: String) {
        self.type = type
        self.data = data
    }
}

