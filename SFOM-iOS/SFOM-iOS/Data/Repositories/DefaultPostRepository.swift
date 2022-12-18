//
//  DefaultPostRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/12.
//

import Combine

final class DefaultPostRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultPostRepository: PostRepository {
    func fetchPost() -> AnyPublisher<[Post], Error> {
        guard let endPoint = APIEndPoints.shared.posts() else {
            return Fail(error: APIEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        let whereFields: [WhereField] = [.isEqualTo("state", value: "published")]
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: PostDTO.self,
                                                whereFields: whereFields,
                                                order: .descending("createdTimestamp"),
                                                limit: nil)
            .map { $0.compactMap { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
