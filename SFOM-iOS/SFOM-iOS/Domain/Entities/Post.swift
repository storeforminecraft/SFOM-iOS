//
//  Post.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import Foundation

struct Post: Codable {
    var documentId: String
    var authorUid: String
    var basedLanguage: String
    var boardId: String
    var bodies: [String: Any]
    var bodyType: String
    var coverImage: String
    var createdTimestamp: Date?
    var id: String
    var modifiedTimestamp: Date?
    var state: String
    var tags: [String]
    var title: String
    var translatedBodies: [String: Any]
    var translatedTitles: [String: String]
}
