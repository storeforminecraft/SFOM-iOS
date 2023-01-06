//
//  SFOMOrderItem.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Foundation

enum SFOMOrderItem: String {
    case newest
    case daily
    case monthly
}

extension SFOMOrderItem {
    var item: String {
        switch self {
        case .newest: return "modifiedTimestamp"
        case .daily: return "point"
        case .monthly: return "point"
        }
    }
    var localized: String {
        switch self {
        case .newest: return StringCollection.Order.newest.localized
        case .daily: return StringCollection.Order.daily.localized
        case .monthly: return StringCollection.Order.monthly.localized
        }
    }
}
