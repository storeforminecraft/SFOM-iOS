//
//  CommentDTO+Mapping.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

struct CommentDTO: Codable {
    let authorUid: String
    let basedLanguage: String
    let childCommentsCount: Int
    let content: String
    let createdTimestamp: Date
    let id: String
    let modifiedTimestamp: Date
    let state: String
}

extension CommentDTO {
    func toDomain() -> Comment {
        return Comment(authorUid: authorUid,
                       basedLanguage: basedLanguage,
                       childCommentsCount: childCommentsCount,
                       content: content,
                       createdTimestamp: createdTimestamp,
                       id: id,
                       modifiedTimestamp: modifiedTimestamp,
                       state: state)
    }
}

extension Comment {
    func toDTO() -> CommentDTO {
        return CommentDTO(authorUid: authorUid,
                          basedLanguage: basedLanguage,
                          childCommentsCount: childCommentsCount,
                          content: content,
                          createdTimestamp: createdTimestamp,
                          id: id,
                          modifiedTimestamp: modifiedTimestamp,
                          state: state)
    }
}
