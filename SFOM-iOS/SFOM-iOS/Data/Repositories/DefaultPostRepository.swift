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

// extension DefaultPostRepository: PostRepository {
//     func fetchPost() -> AnyPublisher<Post, Never> {
//         guard let endPoint = SFOMEndPoint(collection: SFOMEndPoint.SFOMCollection.posts,
//                                           document: nil) else { Just<>}
//         networkService.read(endPoint: endPoint,
//                             type: PostDTO.self)
//         .replaceError(with: nil)
//         .compactMap { $0.toDomain() }
//         .eraseToAnyPublisher()
//     }
// }
