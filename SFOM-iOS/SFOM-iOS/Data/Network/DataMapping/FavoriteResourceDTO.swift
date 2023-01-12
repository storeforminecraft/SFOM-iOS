//
//  FavoriteResourceDTO.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/02.
//

import Foundation

struct FavoriteResourceDTO: Codable {
    let category: String
    let createdTime: Int
    let createdTimestamp: Date
    let databasePath: String?
    let id: String
    let pusherId: String
    let resourceId: String
    
    init(category: String,
         createdTime: Int,
         createdTimestamp: Date,
         databasePath: String? = nil,
         id: String,
         pusherId: String,
         resourceId: String) {
        self.category = category
        self.createdTime = createdTime
        self.createdTimestamp = createdTimestamp
        self.databasePath = databasePath
        self.id = id
        self.pusherId = pusherId
        self.resourceId = resourceId
    }
}
