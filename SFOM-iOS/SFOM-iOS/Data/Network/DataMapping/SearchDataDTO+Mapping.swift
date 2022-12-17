//
//  SearchDataDTO.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Foundation

struct SearchDataDTO: Decodable {
    let authorUid: String
    let category: String
    let createdTimestamp: Date
    let downloadCount: Int
    let id: String
    let likeCount: Int
    let modifiedTimestamp: Date
    let state: String
    let tags: [String]
    let desc: [String: String]
    let name: [String: String]
    
    enum CodingKeys: CodingKey {
        case authorUid, category, createdTimestamp, downloadCount, id, likeCount, modifiedTimestamp, state, tags
        case desc_en, desc_ko
        case name_en, name_ko
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authorUid = try container.decode(String.self, forKey: .authorUid)
        self.category = try container.decode(String.self, forKey: .category)
        self.createdTimestamp = try container.decode(Date.self, forKey: .createdTimestamp)
        self.downloadCount = try container.decode(Int.self, forKey: .downloadCount)
        self.id = try container.decode(String.self, forKey: .id)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.modifiedTimestamp = try container.decode(Date.self, forKey: .modifiedTimestamp)
        self.state = try container.decode(String.self, forKey: .state)
        self.tags = try container.decode([String].self, forKey: .tags)

        let desc_en = try container.decode(String.self, forKey: .desc_en)
        let desc_ko = try container.decode(String.self, forKey: .desc_ko)
        self.desc = ["en": desc_en, "ko": desc_ko]

        let name_en = try container.decode(String.self, forKey: .name_en)
        let name_ko = try container.decode(String.self, forKey: .name_ko)
        self.name = ["en": name_en, "ko": name_ko]
    }
}

extension SearchDataDTO {
    func toDomain() -> SearchData{
        return SearchData(authorUid: authorUid,
                          category: category,
                          createdTimestamp: createdTimestamp,
                          downloadCount: downloadCount,
                          id: id,
                          likeCount: likeCount,
                          modifiedTimestamp: modifiedTimestamp,
                          state: state,
                          tags: tags,
                          desc: desc,
                          name: name)
    }
}
