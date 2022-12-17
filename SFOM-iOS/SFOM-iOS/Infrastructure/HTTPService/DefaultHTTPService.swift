//
//  SFOMHTTPService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Foundation
import Combine

final class DefaultHTTPService {
    private let session = URLSession.shared
    
    func dataTask<D: Decodable>(for url: URL, type: D.Type) -> AnyPublisher<D, URLError> {
        session.dataTaskPublisher(for: url)
            .compactMap { (data, _) in
                try? JSONDecoder().decode(type, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func dataTask<D: Decodable>(for urlRequest: URLRequest, type: D.Type) -> AnyPublisher<D, URLError> {
        session.dataTaskPublisher(for: urlRequest)
            .compactMap { (data, _) in
                try? JSONDecoder().decode(type, from: data)
            }
            .eraseToAnyPublisher()
    }
}
