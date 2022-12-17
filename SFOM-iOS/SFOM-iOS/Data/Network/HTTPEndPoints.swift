//
//  HTTPEndPoints.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Foundation

final class HTTPEndPoints {
    static let shared = HTTPEndPoints()
    private init() { }
}

extension HTTPEndPoints {
    func profile(uid: String) -> HTTPEndPoint {
        return HTTPEndPoint(prevPath: .profile, value: uid)
    }
    
    func increaseResourcesDownloads(resourceId: String) -> HTTPEndPoint {
        return HTTPEndPoint(prevPath: .increaseResourcesDownloads, value: resourceId)
    }
    
    
}
