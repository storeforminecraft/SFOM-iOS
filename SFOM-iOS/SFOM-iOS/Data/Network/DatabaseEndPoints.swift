//
//  DatabaseEndPoints.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/22.
//

import Foundation

final class DatabaseEndPoints {
    static let shared = DatabaseEndPoints()
    private init() { }
}

extension DatabaseEndPoints {
    func user(uid: String) -> DatabaseEndPoint {
        return DatabaseEndPoint(childs: [.users, .another(uid)])
    }
}

