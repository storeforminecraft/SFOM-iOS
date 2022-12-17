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
    func fetchPost() -> AnyPublisher<[Post], Never> {
        guard let endPoint = SFOMEndPoint(collection: SFOMEndPoint.SFOMCollection.posts, document: nil) as FIREndPoint? else {
            return Just<[Post]>([]).eraseToAnyPublisher()
        }
        let whereFields: [WhereField] = [.isEqualTo("state", value: "published")]
        return networkService.readAllWithFilter(endPoint: endPoint, type: PostDTO.self, whereFields: whereFields)
            .map { $0.compactMap { dto in dto.toDomain() } }
            .catch { error in
                print(error)
                return Just<[Post]>([]).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
}
