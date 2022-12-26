//
//  DatabaseEndPoint.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/22.
//

import Foundation

struct DatabaseEndPoint {
    private var childs: [DatabaseChild]
    
    var databaseChilds: [String] {
        return childs.map { $0.value }
    }
    
    init(childs: [DatabaseChild]) {
        self.childs = childs
    }
    
    enum DatabaseChild {
        case users
        case another(_ value: String)
        
        var value: String {
            switch self {
            case .users: return "users"
            case let .another(value): return value
            }
        }
    }
}
