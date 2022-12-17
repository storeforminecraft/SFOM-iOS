//
//  Resource.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/03.
//

import Foundation

struct Resource {
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

    var thumbnail: String? {
        if category == .skin {
            return "\(URLStringManager.urlString(key: .resourceURL))\(fileHash)"
        }
        guard let image = images.first else { return nil }
        return "\(URLStringManager.urlString(key: .imageURL))\(image)"
    }

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
}
