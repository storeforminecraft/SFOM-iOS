//
//  HTTPEndPoint.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/15.
//

import Foundation
import Combine

public struct HTTPEndPoint {
    private var path: Path
    private var value: String?
    
    init(path: Path, value: String? = nil) {
        self.path = path
        self.value = value
    }
    
    var urlString: String {
        let pathList = [self.path.prevPath, self.value, self.path.nextPath]
        return pathList.reduce("/") { partialResult, subPath in
            guard let subPath = subPath else { return partialResult }
            return "\(partialResult)/\(subPath)"
        }
    }
}

extension HTTPEndPoint {
    enum Path: String{
        case userProfile = "v1/profiles"
        case IncreaseResourcesDownloads = "v1/resources"
        case resetPassword = "v1/users"
        
        var prevPath: String {
            return self.rawValue
        }
        
        var nextPath: String? {
            switch self {
            case .userProfile: return nil
            case .increaseResourcesDownloads: return "count/download"
            case .resetPassword: return  "reset_password"
            }
        }
    }
}
