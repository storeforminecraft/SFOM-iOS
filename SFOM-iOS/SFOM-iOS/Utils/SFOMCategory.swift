//
//  SFOMCategory.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/04.
//

import Foundation

enum SFOMCategory: String {
    case addon
    case downloads
    case map
    case mod
    case script
    case seed
    case skin
    case texturepack
    case unknown
    
}

extension SFOMCategory {
    var assets: Assets.Category {
        switch self {
        case .addon: return Assets.Category.addon
        case .downloads: return Assets.Category.downloads
        case .map: return Assets.Category.map
        case .mod: return Assets.Category.mod
        case .script: return Assets.Category.script
        case .seed: return Assets.Category.seed
        case .skin: return Assets.Category.skin
        case .texturepack: return Assets.Category.texturepack
        case .unknown: return Assets.Category.unknown
        }
    }
    
    var localized: String {
        switch self {
        case .addon: return StringCollection.Category.addon.localized
        case .downloads: return StringCollection.Category.downloads.localized
        case .map: return StringCollection.Category.map.localized
        case .mod: return StringCollection.Category.mod.localized
        case .script: return StringCollection.Category.script.localized
        case .seed: return StringCollection.Category.seed.localized
        case .skin: return StringCollection.Category.skin.localized
        case .texturepack: return StringCollection.Category.texturepack.localized
        case .unknown: return StringCollection.Category.unknown.localized
        }
    }
}
