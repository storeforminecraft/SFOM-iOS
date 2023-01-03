//
//  DefaultSearchRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Foundation
import Combine

final class DefaultSearchRepository {
    private let networkService: NetworkService
    private let httpService: HTTPService
    
    init(networkService: NetworkService, httpService: HTTPService) {
        self.networkService = networkService
        self.httpService = httpService
    }
}

extension DefaultSearchRepository: SearchRepository {
    func search(keyword: String, page: Int, tag: String?, sort: String?) -> AnyPublisher<[Resource],Error>{
        let endPoint = HTTPEndPoints.shared.search(keyword: keyword, page: page, tag: tag, sort: sort)
        return self.httpService.dataTaskPublisher(endPoint: endPoint, type: [SearchDataDTO].self)
            .flatMap{ [weak self] searchDataList -> AnyPublisher<[Resource], Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return searchDataList.publisher
                    .flatMap { searchDataDTO -> AnyPublisher<Resource, Error> in
                        guard let endPoint = NetworkEndPoints.shared.resources(doc: searchDataDTO.id) else {
                            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
                        }
                        return self.networkService.read(endPoint: endPoint, type: ResourceDTO.self)
                            .map{ $0.toDomain() }
                            .eraseToAnyPublisher()
                    }
                    .map{ resource -> Resource? in resource }
                    .replaceError(with: nil)
                    .compactMap{ $0 }
                    .collect()
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
