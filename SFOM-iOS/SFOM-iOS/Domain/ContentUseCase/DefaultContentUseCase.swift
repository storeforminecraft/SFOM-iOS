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
    
    func fetchUserComment(resourceId: String, limit: Int?) -> AnyPublisher<[UserComment], Error> {
        resourceReposiotry.fetchResourceComments(resourceId: resourceId, limit: 5)
            .flatMap { [weak self] comments -> AnyPublisher<UserComment?, Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return comments.publisher
                    .map { (resourceId, $0) }
                    .flatMap(self.fetchUserWithComment(resourceId:comment:))
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
    
    func fetchThumb(resourceId: String) -> AnyPublisher<Bool, Error> {
        resourceReposiotry.fetchThumb(resourceId: resourceId)
    }
    
    func pushThumb(category: String, resourceId: String) -> AnyPublisher<Bool, Error> {
        return resourceReposiotry.pushThumb(category: category, resourceId: resourceId)
            .flatMap { _ in self.fetchThumb(resourceId: resourceId) }
            .eraseToAnyPublisher()
    }
    
    func deleteThumb(resourceId: String) -> AnyPublisher<Bool, Error> {
        return resourceReposiotry.deleteThumb(resourceId: resourceId)
            .flatMap { _ in self.fetchThumb(resourceId: resourceId) }
            .eraseToAnyPublisher()
    }
}

private extension DefaultContentUseCase {
    func fetchUserWithComment(resourceId: String, comment: Comment) -> AnyPublisher<UserComment, Error> {
        return resourceReposiotry.fetchResourceChildComment(resourceId: resourceId, commentId: comment.id)
            .flatMap(self.fetchChildCommentUser(childComments:))
            .flatMap { [weak self] childComment -> AnyPublisher<UserComment, Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return self.userRepository.fetchUser(uid: comment.authorUid)
                    .map{ UserComment(user: $0, comment: comment, childComment: childComment) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchChildCommentUser(childComments: [Comment]) -> AnyPublisher<[UserComment], Error>{
        return childComments.publisher
            .flatMap { [weak self] comment -> AnyPublisher<UserComment?, Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return self.userRepository.fetchUser(uid: comment.authorUid)
                    .map{ UserComment(user: $0, comment: comment) }
                    .eraseToAnyPublisher()
            }
            .compactMap { $0 }
            .collect()
            .eraseToAnyPublisher()
    }
}
