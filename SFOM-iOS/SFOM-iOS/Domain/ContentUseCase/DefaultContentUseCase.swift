//
//  DefaultContentUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/21.
//

import Combine

final class DefaultContentUseCase {
    private let authRepository: AuthRepository
    private let resourceReposiotry: ResourceRepository
    private let userRepository: UserRepository
    
    init(authRepository: AuthRepository,
         resourceReposiotry: ResourceRepository,
         userRepository: UserRepository) {
        self.authRepository = authRepository
        self.resourceReposiotry = resourceReposiotry
        self.userRepository = userRepository
    }
}

extension DefaultContentUseCase: ContentUseCase {
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
    
    func fetchUserComment(resourceId: String) -> AnyPublisher<[UserComment], Error> {
        resourceReposiotry.fetchResourceComments(resourceId: resourceId)
            .flatMap { [weak self] comments -> AnyPublisher<UserComment?, Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return comments.publisher
                    .flatMap(self.fetchUserWithComment(comment:))
                    .map{ userComment -> UserComment? in userComment }
                    .replaceError(with: nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .compactMap{ $0 }
            .collect()
            .eraseToAnyPublisher()
    }
    
    func fetchUserResources(uid: String) -> AnyPublisher<[Resource], Error> {
        resourceReposiotry.fetchUserResources(uid: uid, limit: 5)
    }
}

private extension DefaultContentUseCase {
    func fetchUserWithComment(comment: Comment) -> AnyPublisher<UserComment, Error> {
        return userRepository.fetchUser(uid: comment.authorUid)
            .map{ UserComment(user: $0, comment: comment) }
            .eraseToAnyPublisher()
    }
}


