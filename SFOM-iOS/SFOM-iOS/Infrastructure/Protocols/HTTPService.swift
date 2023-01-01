//
//  HTTPService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Foundation
import Combine

public enum HTTPServiceError {
    case wrongURLRequestError
    case notFoundError
    case internalServerError
    case badResponseError
    case statusCodeError
}

extension HTTPServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongURLRequestError:
            return NSLocalizedString("wrong URLRequest", comment: "wrong URLRequest")
        case .notFoundError:
            return NSLocalizedString("not found Data", comment: "not found Data")
        case .internalServerError:
            return NSLocalizedString("internal server Error", comment: "check internal server")
        case .badResponseError:
            return NSLocalizedString("bad Response Error", comment: "bad Response")
        case .statusCodeError:
            return NSLocalizedString("status code Error", comment: "bad status code")
        }
    }
}

protocol HTTPService {
    func dataTaskPublisher(endPoint: HTTPEndPoint) -> AnyPublisher<Data, Error>
    func dataTaskPublisher<D: Decodable>(endPoint: HTTPEndPoint, type: D.Type) -> AnyPublisher<D, Error>
    // func downloadTaskPublisher
}
