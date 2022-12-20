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
    
    var assets: Assets.Category{
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
        case .addon: return Localized.Category.addon
        case .downloads: return Localized.Category.downloads
        case .map: return Localized.Category.map
        case .mod: return Localized.Category.mod
        case .script: return Localized.Category.script
        case .seed: return Localized.Category.seed
        case .skin: return Localized.Category.skin
        case .texturepack: return Localized.Category.texturepack
        case .unknown: return Localized.Category.unknown
        }
    }
}
