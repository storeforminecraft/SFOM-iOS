//
//  FavoriteResourceDTO.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/02.
//

import Foundation

struct FavoriteResourceDTO: Codable {
    let category: String
    let createdTime: Date
    let id: String
    let pusherId: String
    let resourceId: String
}
