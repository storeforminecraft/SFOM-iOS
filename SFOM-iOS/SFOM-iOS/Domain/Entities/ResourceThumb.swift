//
//  ResourceThumb.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/12.
//

import Foundation

struct ResourceThumb {
    static let empty: ResourceThumb = ResourceThumb(thumbCount: 0, isThumb: false)
    
    let thumbCount: Int
    let isThumb: Bool
}
