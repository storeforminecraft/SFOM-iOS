//
//  DefaultProfileUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/02.
//

import Combine

final class DefaultProfileUseCase {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    private let resourceRepository: ResourceRepository
    
    init(authRepository: AuthRepository,
         userRepository: UserRepository,
         resourceRepository:ResourceRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.resourceRepository = resourceRepository
    }
}

extension DefaultProfileUseCase: ProfileUseCase {
    func fetchCurrentUserWithUidChanges() -> AnyPublisher<User?, Error> {
        return authRepository.uidChanges()
            .flatMap { uid -> AnyPublisher<User?, Error> in
                if uid != nil {
                    return self.userRepository.fetchCurrentUser()
                        .map { user -> User? in user }
                        .eraseToAnyPublisher()
                } else {
                    return Just<User?>(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchUser(uid: String) -> AnyPublisher<User, Error> {
        userRepository.fetchUser(uid: uid)
    }
    
    func fetchUserResources(uid: String) -> AnyPublisher<[Resource], Error> {
        resourceRepository.fetchUserResources(uid: uid, limit: nil)
    }
    
    func fetchUserFavoriteResources(uid: String) -> AnyPublisher<[Resource], Error> {
        resourceRepository.fetchUserFavoriteResources(uid: uid)
    }
}
