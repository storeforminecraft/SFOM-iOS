//
//  SFOMMoreMenu.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import Foundation

enum SFOMMoreMenu: String {
    case download
    case notice
    case settings
    case myComments
    case signOut
    
}

extension SFOMMoreMenu {
    var assets: Assets.MoreMenu {
        switch self {
        case .download: return .download
        case .notice: return .notice
        case .settings: return .settings
        case .myComments: return .myComments
        case .signOut: return .signOut
        }
    }
    
    var localized: String {
        switch self {
        case .download: return Localized.MoreMenu.download
        case .notice: return Localized.MoreMenu.notice
        case .settings: return Localized.MoreMenu.settings
        case .myComments: return Localized.MoreMenu.myComments
        case .signOut: return Localized.MoreMenu.signOut
        }
    }
}
