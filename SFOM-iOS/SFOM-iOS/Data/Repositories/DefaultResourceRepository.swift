//
//  DefaultResourceRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Combine

final class DefaultResourceRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultResourceRepository: ResourceRepository {
    func fetchResource(resourceId: String) -> AnyPublisher<Resource, Error> {
        guard let endPoint = APIEndPoints.shared.resources(doc: resourceId) else {
            return Fail(error: APIEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.read(endPoint: endPoint, type: ResourceDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
