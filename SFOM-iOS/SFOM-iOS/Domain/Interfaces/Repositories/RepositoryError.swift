//
//  RepositoryError.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

enum RepositoryError {
    case castingError
}

extension RepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .castingError:
            return NSLocalizedString("Casting Error", comment: "counln't cast Repository")
        }
    }
}
