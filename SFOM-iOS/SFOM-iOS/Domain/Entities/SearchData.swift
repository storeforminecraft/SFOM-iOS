//
//  SearchContent.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/03.
//

import Foundation

struct SearchData: Codable {
    let authorUid: String
    let category: String
    let createdTimestamp: Date
    let downloadCount: Int
    let id: String
    let likeCount: Int
    let modifiedTimestamp: Date
    let state: String
    let tags: [String]
    private let _desc: [String: String]
    private let _name: [String: String]
    
    var desc: String {
        guard let tempValue = _desc.first?.value else { return "" }
        return _desc[StringCollection.location] ?? tempValue
    }
    
    var name: String {
        guard let tempValue = _name.first?.value else { return "" }
        return _name[StringCollection.location] ?? tempValue
    }
    
    init(authorUid: String,
         category:
         String, createdTimestamp: Date,
         downloadCount: Int,
         id: String,
         likeCount: Int,
         modifiedTimestamp: Date,
         state: String,
         tags: [String],
         desc: [String : String],
         name: [String : String]) {
        self.authorUid = authorUid
        self.category = category
        self.createdTimestamp = createdTimestamp
        self.downloadCount = downloadCount
        self.id = id
        self.likeCount = likeCount
        self.modifiedTimestamp = modifiedTimestamp
        self.state = state
        self.tags = tags
        self._desc = desc
        self._name = name
    }
}
