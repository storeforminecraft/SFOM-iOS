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
    
    func fetchUserComment(resourceId: String) -> AnyPublisher<[UserComment], Error> {
        resourceReposiotry.fetchResourceComments(resourceId: resourceId)
            .flatMap { [weak self] comments -> AnyPublisher<UserComment?, Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return comments.publisher
                    .flatMap(self.fetchUserWithComment(comment:))
                    .map{ result -> UserComment? in UserComment(user:result.0, comment: result.1) }
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
    func fetchUserWithComment(comment: Comment) -> AnyPublisher<(User, Comment), Error> {
        return userRepository.fetchUser(uid: comment.authorUid)
            .map{ (user: $0, comment: comment) }
            .eraseToAnyPublisher()
    }
}


