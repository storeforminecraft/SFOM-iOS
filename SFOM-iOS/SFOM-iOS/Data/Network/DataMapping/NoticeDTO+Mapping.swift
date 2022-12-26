//
//  NoticeDTO+Mapping.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import Foundation

struct NoticeDTO: Decodable {
    let authorUid: String
    let basedLanguage: String
    let boardId: String
    let title: String
    let content: String
    let createdTimestamp: Date
    let id: String
    let modifiedTimestamp: Date
    let translatedContent: [String: String]
    let translatedTitles: [String: String]
}

extension NoticeDTO{
    func toDomain() -> Notice {
        Notice(authorUid: authorUid,
               basedLanguage: basedLanguage,
               boardId: boardId,
               title: title,
               content: content,
               createdTimestamp: createdTimestamp,
               id: id,
               modifiedTimestamp: modifiedTimestamp,
               translatedContent: translatedContent,
               translatedTitles: translatedTitles)
    }
}
