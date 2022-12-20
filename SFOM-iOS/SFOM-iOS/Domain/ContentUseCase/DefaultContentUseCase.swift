//
//  DefaultContentUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/21.
//

import Combine

final class DefaultContentUseCase {
    private let resourceReposiotry: ResourceRepository
    private let userRepository: UserRepository
    
    init(resourceReposiotry: ResourceRepository,
         userRepository: UserRepository) {
        self.resourceReposiotry = resourceReposiotry
        self.userRepository = userRepository
    }
}

extension DefaultContentUseCase: ContentUseCase {
    func fetchUser(uid: String) -> AnyPublisher<User, Error> {
        userRepository.fetchUser(uid: uid)
    }
    
    func fetchComment(resourceId: String) -> AnyPublisher<[Comment], Error> {
        resourceReposiotry.fetchResourceComments(resourceId: resourceId)
    }
    
    func fetchUserResources(uid: String) -> AnyPublisher<[Resource], Error> {
        resourceReposiotry.fetchUserResources(uid: uid)
    }
}


