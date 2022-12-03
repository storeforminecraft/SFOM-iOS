//
//  Resource.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/03.
//

import Foundation

struct Resource: Codable {
    let authorUid: String
    let basedLanguage: String
    let category: String
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
}
