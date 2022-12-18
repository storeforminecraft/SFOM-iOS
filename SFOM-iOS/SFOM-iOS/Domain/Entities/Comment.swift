//
//  Comment.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

struct Comment {
    let authorUid: String
    let basedLanguage: String
    let childCommentsCount: Int
    let content: String
    let createdTimestamp: Date
    let id: String
    let modifiedTimestamp: Date
    let state: String
}
