//
//  SFOMDetailCategory.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/05.
//

import Foundation

enum SFOMDetailCategory: String {
    case all
    
    case building
    case content
    case escape
    case land
    case pvp
    case adventure
    
    case boys
    case girls
    case characters
    case games
    case animal
    
    case mountain
    case cave
    case island
    case plain
    
    case kind16x16
    case kind32x32
    case kind64x64
    case kind128x128
    case shaders
}

extension SFOMDetailCategory {
    var localized: String {
        switch self {
        case .all: return StringCollection.DetailCategory.all.localized
        
        case .building: return StringCollection.DetailCategory.building.localized
        case .content: return StringCollection.DetailCategory.content.localized
        case .escape: return StringCollection.DetailCategory.escape.localized
        case .land: return StringCollection.DetailCategory.land.localized
        case .pvp: return StringCollection.DetailCategory.pvp.localized
        case .adventure: return StringCollection.DetailCategory.adventure.localized
        
        case .boys: return StringCollection.DetailCategory.boys.localized
        case .girls: return StringCollection.DetailCategory.girls.localized
        case .characters: return StringCollection.DetailCategory.characters.localized
        case .games: return StringCollection.DetailCategory.games.localized
        case .animal: return StringCollection.DetailCategory.animal.localized
        
        case .mountain: return StringCollection.DetailCategory.mountain.localized
        case .cave: return StringCollection.DetailCategory.cave.localized
        case .island: return StringCollection.DetailCategory.island.localized
        case .plain: return StringCollection.DetailCategory.plain.localized
        
        case .kind16x16: return StringCollection.DetailCategory.kind16x16.localized
        case .kind32x32: return StringCollection.DetailCategory.kind32x32.localized
        case .kind64x64: return StringCollection.DetailCategory.kind64x64.localized
        case .kind128x128: return StringCollection.DetailCategory.kind128x128.localized
        case .shaders: return StringCollection.DetailCategory.shaders.localized
        }
    }
}
