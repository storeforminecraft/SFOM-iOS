//
//  Font+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import SwiftUI

extension Font {
    static let SFOMLargeTitleFont: Font = .system(size: 30, weight: .bold)
    static let SFOMTitleFont: Font = .system(size: 18, weight: .bold)
    static let SFOMMediumFont: Font = .system(size: 22)
    static let SFOMSmallFont: Font = .system(size: 16)
    static let SFOMExtraSmallFont: Font = .system(size: 12)
    
    static let SFOMFont10: Font = .custom("Pretendard", size: 10) //.system(size: 10)
    static let SFOMFont12: Font = .custom("Pretendard", size: 12) //.system(size: 12)
    static let SFOMFont14: Font = .custom("Pretendard", size: 14) //.system(size: 14)
    static let SFOMFont16: Font = .custom("Pretendard", size: 16) //.system(size: 16)
    static let SFOMFont18: Font = .custom("Pretendard", size: 18) //.system(size: 18)
}
