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
        return _desc[Localized.location] ?? tempValue
    }
    
    var name: String {
        guard let tempValue = _name.first?.value else { return "" }
        return _name[Localized.location] ?? tempValue
    }

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
        self._desc = ["en": desc_en, "ko": desc_ko]

        let name_en = try container.decode(String.self, forKey: .name_en)
        let name_ko = try container.decode(String.self, forKey: .name_ko)
        self._name = ["en": name_en, "ko": name_ko]
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(authorUid, forKey: .authorUid)
        try container.encode(category, forKey: .category)
        try container.encode(createdTimestamp, forKey: .createdTimestamp)
        try container.encode(downloadCount, forKey: .downloadCount)
        try container.encode(id, forKey: .id)
        try container.encode(likeCount, forKey: .likeCount)
        try container.encode(modifiedTimestamp, forKey: .modifiedTimestamp)
        try container.encode(state, forKey: .state)
        try container.encode(tags, forKey: .tags)

        try container.encode(_desc["en"], forKey: .desc_en)
        try container.encode(_desc["ko"], forKey: .desc_en)
        try container.encode(_name["en"], forKey: .name_en)
        try container.encode(_name["ko"], forKey: .name_ko)
    }
}
