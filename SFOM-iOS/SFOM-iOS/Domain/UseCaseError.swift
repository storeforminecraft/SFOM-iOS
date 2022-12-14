//
//  UseCaseError.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

enum UseCaseError {
    case noObjectError
    case noDataError
}

extension UseCaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noObjectError:
            return NSLocalizedString("No Object Error", comment: "counln't found Object")
        case .noDataError:
            return NSLocalizedString("No Data Error", comment: "Couldn't found data")
        }
    }
}
