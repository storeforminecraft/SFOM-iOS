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
    func search(keyword: String, page: Int) -> HTTPEndPoint {
        return HTTPEndPoint(method: .get, path: .resource, query: [.keyword: keyword,
                                                                   .page: "\(page)"])
    }
    
    func userProfile(uid: String) -> HTTPEndPoint {
        return HTTPEndPoint(method:.get, path: .userProfile, value: uid)
    }
    
    func increaseResourcesDownloads(resourceId: String) -> HTTPEndPoint {
        return HTTPEndPoint(method:.post, path: .increaseResourcesDownloads, value: resourceId)
    }
    
    func resetPassword(email: String) -> HTTPEndPoint {
        return HTTPEndPoint(method:.get, path: .resetPassword, value: email)
    }
}
