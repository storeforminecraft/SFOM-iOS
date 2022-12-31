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
    
    func fetchResources(resourceIds: [String]) -> AnyPublisher<[UserResource], Error> {
        resourceIds
            .publisher
            .flatMap{ [weak self] resourceId -> AnyPublisher<UserResource?, Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return self.resourceReposiotry.fetchResource(resourceId: resourceId)
                    .flatMap(self.fetchUserWithResource(resource:))
                    .map{ userResource -> UserResource? in userResource }
                    .replaceError(with: nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .compactMap{ $0 }
            .collect()
            .eraseToAnyPublisher()
    }
}

private extension DefaultPostUseCase {
    func fetchUserWithResource(resource: Resource) -> AnyPublisher<UserResource, Error> {
        userRepository.fetchUser(uid: resource.authorUid)
            .map { user in UserResource(user: user, resource: resource) }
            .eraseToAnyPublisher()
    }
}
