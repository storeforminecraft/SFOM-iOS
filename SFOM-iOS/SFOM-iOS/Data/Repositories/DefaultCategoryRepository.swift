//
//  DefaultCategoryRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Combine

final class DefaultCategoryRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultCategoryRepository: CategoryRepository {
    func fetchCategory(category: String, order: String, page: Int, limit: Int) -> AnyPublisher<[Resource], Error> {
        guard let endPoint = NetworkEndPoints.shared.resources(doc: nil) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                         type: ResourceDTO.self,
                                         whereFields: [.isEqualTo("category", value: category)],
                                         order: .descending(order),
                                         limit: limit)
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
}
