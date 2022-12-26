//
//  Notice.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import Foundation

struct Notice {
    let authorUid: String?
    let basedLanguage: String
    let boardId: String
    let title: String
    let content: String
    let createdTimestamp: Date
    let id: String
    let modifiedTimestamp: Date
    let translatedContents: [String: String]
    let translatedTitles: [String: String]
    
    var localizedTitle: String {
        let location = Localized.location
        if basedLanguage == location {
            return title
        } else {
            return translatedTitles[location] ?? title
        }
    }
    
    var localizedContent: String {
        let location = Localized.location
        if basedLanguage == location {
            return content
        } else {
            return translatedContents[location] ?? content
        }
    }
}
