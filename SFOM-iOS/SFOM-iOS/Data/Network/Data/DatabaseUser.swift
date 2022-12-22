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
        var values: [String: Any?] = [:]
        handles.forEach { handle in
            switch handle {
            case let .set(element):
                values[element.key] = element
            case let .delete(element):
                values[element.key] = nil
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
        case lastSignInTime(_ value: String? = nil)
        case nickname(_ value: String? = nil)
        case profileImag(_ value: String? = nil)
        case uid(_ value: String? = nil)
        case userRestricted(_ value: String? = nil)
        
        var key: String {
            switch self {
            case .email: return "email"
            case .introduction: return "introduction"
            case .language: return "language"
            case .lastSignInDeviceId: return "lastSignInDeviceId"
            case .lastSignInTime: return "lastSignInTime"
            case .nickname: return "nickname"
            case .profileImag: return "profileImag"
            case .uid: return "uid"
            case .userRestricted: return "userRestricted"
            }
        }
        
        var value: Any? {
            switch self {
            case let .email(value: value): return value
            case let .introduction(value: value): return value
            case let .language(value: value): return value
            case let .lastSignInDeviceId(value: value): return value
            case let .lastSignInTime(value: value): return value
            case let .nickname(value: value): return value
            case let .profileImag(value: value): return value
            case let .uid(value: value): return value
            case let .userRestricted(value: value): return value
            }
        }
    }
}
