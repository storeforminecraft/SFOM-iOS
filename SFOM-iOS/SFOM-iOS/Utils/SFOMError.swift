//
//  SFOMError.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import Foundation

public enum SFOMError {
    case objectError
    case noDataError
}

extension SFOMError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .objectError:
            return NSLocalizedString("not found object(self)", comment: "could not found object(self)")
        case .noDataError:
            return NSLocalizedString("not found data", comment: "could not found data")
        }
    }
}
