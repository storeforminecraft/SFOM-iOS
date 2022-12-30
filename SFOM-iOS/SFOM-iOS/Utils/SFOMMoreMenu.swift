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
        case .download: return StringCollection.MoreMenu.download.localized
        case .notice: return StringCollection.MoreMenu.notice.localized
        case .settings: return StringCollection.MoreMenu.settings.localized
        case .myComments: return StringCollection.MoreMenu.myComments.localized
        case .signOut: return StringCollection.MoreMenu.signOut.localized
        }
    }
}
