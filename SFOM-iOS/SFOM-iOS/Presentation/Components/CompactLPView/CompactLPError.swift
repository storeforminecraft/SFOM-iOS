//
//  CompactLinkPresentation.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

enum CompactLPError {
    case urlError
    case noDataError
}

extension CompactLPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("URL Error", comment: "Invalid url")
        case .noDataError:
            return NSLocalizedString("No Data Error", comment: "Couldn't found data")
        }
    }
    
}

