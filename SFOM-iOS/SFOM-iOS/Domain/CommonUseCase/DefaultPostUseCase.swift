//
//  DefaultPostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/30.
//

import Combine

final class DefaultPostUseCase {
    private let userRepository: UserRepository
    private let resourceReposiotry: ResourceRepository
    
    init(userRepository: UserRepository,
         resourceReposiotry: ResourceRepository) {
        self.userRepository = userRepository
        self.resourceReposiotry = resourceReposiotry
    }
}

extension DefaultPostUseCase: PostUseCase {
    func fetchUser(uid: String) -> AnyPublisher<User, Error> {
        userRepository.fetchUser(uid: uid)
    }
    
    func fetchResources(resourceIds: [String]) -> AnyPublisher<[Resource], Error> {
        resourceIds
            .publisher
            .flatMap (resourceReposiotry.fetchResource(resourceId:))
            .collect()
            .eraseToAnyPublisher()
    }
}
