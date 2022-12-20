//
//  DefaultSearchRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Foundation
import Combine

final class DefaultSearchRepository {
    private let httpService: HTTPService
    
    init(httpService: HTTPService) {
        self.httpService = httpService
    }
}

extension DefaultSearchRepository: SearchRepository {
    func search(keyword: String, page: Int, tag: String?, sort: String?) -> AnyPublisher<[SearchData],Error>{
        let endPoint = HTTPEndPoints.shared.search(keyword: keyword, page: page, tag: tag, sort: sort)
        return self.httpService.dataTaskPublisher(endPoint: endPoint, type: [SearchDataDTO].self)
            .map { $0.map{ $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
