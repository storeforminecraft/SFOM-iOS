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
    func search(keyword: String, page: Int, tag: String?, sort: String?) -> HTTPEndPoint {
        var query: [HTTPEndPoint.queryKey: String] = [.keyword: keyword,
                                                      .page: "\(page)"]
        if let tag = tag { query[.tag] = tag }
        if let sort = sort { query[.sort] = sort }
        return HTTPEndPoint(method: .get, path: .resource, query: query)
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
