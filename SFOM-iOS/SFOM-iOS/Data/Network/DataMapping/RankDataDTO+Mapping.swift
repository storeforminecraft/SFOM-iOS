//
//  RankDataDTO.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Foundation

struct RankDataDTO: Decodable{    
    let category: String
    let id: String
    let point: Float
    let tags: [String]
    
    enum CodingKeys: CodingKey {
        case category
        case id
        case point
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(String.self, forKey: .category)
        self.id = try container.decode(String.self, forKey: .id)
        self.point = try container.decode(Float.self, forKey: .point)
        self.tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
    
    }
}
