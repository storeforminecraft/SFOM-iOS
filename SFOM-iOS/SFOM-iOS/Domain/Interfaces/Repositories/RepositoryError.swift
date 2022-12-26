//
//  RepositoryError.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

enum RepositoryError {
    case noObjectError
    case castingError
    case noAuthError
}

extension RepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noObjectError:
            return NSLocalizedString("No Object Error", comment: "counln't found Object")
        case .castingError:
            return NSLocalizedString("Casting Error", comment: "counln't cast Repository")
        case .noAuthError:
            return NSLocalizedString("No Auth Error", comment: "Don't have permission")
        }
    }
}
