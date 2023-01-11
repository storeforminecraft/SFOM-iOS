//
//  DatabaseUser.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/22.
//

import Foundation

struct DatabaseUser {
    private(set) var values: [String: Any?]
    
    init(handles: [Handle]) {
        var values: [String: Any] = [:]
        handles.forEach { handle in
            switch handle {
            case let .set(element):
                values[element.key] = element.value
            case let .delete(element):
                values[element.key] = nil
                break
            }
        }
        self.values = values
    }
}

extension DatabaseUser {
    enum Handle {
        case `set` (_ element: Element)
        case delete (_ element: Element)
    }
    
    enum Element {
        case email(_ value: String? = nil)
        case introduction(_ value: String? = nil)
        case language(_ value: String? = nil)
        case lastSignInDeviceId(_ value: String? = nil)
        case lastSignInTime(_ value: Date? = nil)
        case nickname(_ value: String? = nil)
        case profileImage(_ value: String? = nil)
        case uid(_ value: String? = nil)
        
        var key: String {
            switch self {
            case .email: return "email"
            case .introduction: return "introduction"
            case .language: return "language"
            case .lastSignInDeviceId: return "lastSignInDeviceId"
            case .lastSignInTime: return "lastSignInTime"
            case .nickname: return "nickname"
            case .profileImage: return "profileImage"
            case .uid: return "uid"
            }
        }
        
        var value: Any? {
            switch self {
            case let .email(value: value): return value as? NSString
            case let .introduction(value: value): return value as? NSString
            case let .language(value: value): return value as? NSString
            case let .lastSignInDeviceId(value: value): return value as? NSString
            case let .lastSignInTime(value: value): return value?.timeIntervalSince1970 as? NSNumber
            case let .nickname(value: value): return value as? NSString
            case let .profileImage(value: value): return value as? NSString
            case let .uid(value: value): return value as? NSString
            }
        }
    }
}
