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
    case activity
    case signOut
    
}

extension SFOMMoreMenu {
    var assets: Assets.MoreMenu {
        switch self {
        case .download: return .download
        case .notice: return .notice
        case .settings: return .settings
        case .activity: return .activity
        case .signOut: return .signOut
        }
    }
    
    var localized: String {
        switch self {
        case .download: return StringCollection.MoreMenu.download.localized
        case .notice: return StringCollection.MoreMenu.notice.localized
        case .settings: return StringCollection.MoreMenu.settings.localized
        case .activity: return StringCollection.MoreMenu.activity.localized
        case .signOut: return StringCollection.MoreMenu.signOut.localized
        }
    }
}
