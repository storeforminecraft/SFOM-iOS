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
    let baseURL: String = "https://asia-northeast3-storeforminecraft.cloudfunctions.net/v1"
    
}

extension DefaultHTTPService {
    
}

private extension DefaultHTTPService {
    private func createURL(endPoint: HTTPEndPoint) {
        guard let url = URL(string: baseURL + endPoint.path) else { return }
        let request = URLRequest(url: url)
    }
    
    private func dataTask<D: Decodable>(for url: URL, type: D.Type) -> AnyPublisher<D, URLError> {
        session.dataTaskPublisher(for: url)
            .compactMap { (data, _) in
                try? JSONDecoder().decode(type, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    private func dataTask<D: Decodable>(for urlRequest: URLRequest, type: D.Type) -> AnyPublisher<D, URLError> {
        session.dataTaskPublisher(for: urlRequest)
            .compactMap { (data, _) in
                try? JSONDecoder().decode(type, from: data)
            }
            .eraseToAnyPublisher()
    }
}


// AF.request(,
//            method: .get,
//            parameters: ["keyword": searchText,
//                         "pagenation": pagenation],
//            encoding: URLEncoding.queryString)
//     .responseDecodable(of: [SearchData].self) { response i)
//     }
// }
