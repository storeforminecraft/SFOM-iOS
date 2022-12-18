//
//  SFOMHTTPService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Foundation
import Combine

final class DefaultHTTPService {
    private let baseURL = URLStringManager.urlString(key: .httpURL)
    private let session = URLSession.shared
}

extension DefaultHTTPService : HTTPService{
    func dataTaskPublisher(endPoint: HTTPEndPoint) -> AnyPublisher<Bool, Error> {
        guard let urlRequest = urlRequest(endPoint: endPoint) else {
            return Fail(error: HTTPServiceError.wrongURLRequestError).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: urlRequest)
            .mapError{ $0 }
            .flatMap{ (data, response) -> AnyPublisher<Bool, Error> in
                do {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                        throw HTTPServiceError.badResponseError
                    }
                    switch statusCode {
                    case (200..<300): break
                    case (404): throw HTTPServiceError.notFoundError
                    case (500): throw HTTPServiceError.internalServerError
                    default: throw HTTPServiceError.statusCodeError
                    }
                    return Just<Bool>(true)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .catch { Fail(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func dataTaskPublisher<D: Decodable>(endPoint: HTTPEndPoint, type: D.Type) -> AnyPublisher<D, Error> {
        guard let urlRequest = urlRequest(endPoint: endPoint) else {
            return Fail(error: HTTPServiceError.wrongURLRequestError).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: urlRequest)
            .mapError{ $0 }
            .flatMap{ (data, response) -> AnyPublisher<D, Error> in
                do {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                        throw HTTPServiceError.badResponseError
                    }
                    switch statusCode {
                    case (200..<300): break
                    case (404): throw HTTPServiceError.notFoundError
                    case (500): throw HTTPServiceError.internalServerError
                    default: throw HTTPServiceError.statusCodeError
                    }
                    let data = try JSONDecoder().decode(type, from: data)
                    return Just<D>(data)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

private extension DefaultHTTPService {
    private func url(endPoint: HTTPEndPoint) -> URL? {
        if let queryItem = endPoint.queryItem {
            guard var urlComponents = URLComponents(string: "\(baseURL)\(endPoint)") else { return nil }
            urlComponents.queryItems = queryItem
            guard let url = urlComponents.url else { return nil }
            return url
        }else {
            guard let url = URL(string: "\(baseURL)\(endPoint)") else { return nil }
            return url
        }
    }
    
    private func urlRequest(endPoint: HTTPEndPoint) -> URLRequest? {
        guard let url = url(endPoint: endPoint) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.httpMethod
        return request
    }
}
