//
//  HTTPEndPoint.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/15.
//

import Foundation
import Combine

public struct HTTPEndPoint {
    private let method: Method
    private let path: Path
    private let value: String?
    private let query: [String: String]?
    
    init(method: Method,
         path: Path,
         value: String? = nil,
         query: [queryKey: String]? = nil) {
        self.method = method
        self.path = path
        self.value = value
        
        self.query = Dictionary(uniqueKeysWithValues: query?.map({ (key: queryKey, value: String) in
            return (key.key, value)
        }) ?? [])
    }
    
    var httpMethod: String {
        return method.rawValue
    }
    
    var urlString: String {
        let pathList = [self.path.prevPath, self.value, self.path.nextPath]
        return pathList.reduce("") { partialResult, subPath in
            guard let subPath = subPath else { return partialResult }
            return "\(partialResult)/\(subPath)"
        }
    }
    
    var queryItem: [URLQueryItem]? {
        return query?.compactMap({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        })
    }
}

extension HTTPEndPoint {
    enum Method: String {
        case get
        case post
    }
    
    enum Path: String{
        case resource = "v1/Resource"
        case userProfile = "v1/profiles"
        case increaseResourcesDownloads = "v1/resources"
        case resetPassword = "v1/users"
        
        var prevPath: String {
            return self.rawValue
        }
        
        var nextPath: String? {
            switch self {
            case .resource: return nil
            case .userProfile: return nil
            case .increaseResourcesDownloads: return "count/download"
            case .resetPassword: return  "reset_password"
            }
        }
    }
    
    enum queryKey: String {
        case keyword
        case page
        case tag
        case sort
    
        var key: String {
            return self.rawValue
        }
    }
}
