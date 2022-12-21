//
//  DefaultPostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Combine

final class DefaultHomeUseCase {
    private let authRepository: AuthRepository
    private let postRepository: PostRepository
    private let userRepository: UserRepository
    private let resourceRepository: ResourceRepository
    private let commentEventRepository: CommentEventRepository
    
    init(authRepository: AuthRepository,
         postRepository: PostRepository,
         userRepository: UserRepository,
         resourceRepository:ResourceRepository,
         commentEventRepository: CommentEventRepository) {
        self.authRepository = authRepository
        self.postRepository = postRepository
        self.userRepository = userRepository
        self.resourceRepository = resourceRepository
        self.commentEventRepository = commentEventRepository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
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
    
    func fetchPost() -> AnyPublisher<[Post], Error> {
        return postRepository.fetchPost()
    }
    
    func fetchRecentComment() -> AnyPublisher<[RecentComment], Error> {
        return commentEventRepository
            .fetchCommentEvent()
            .flatMap { [weak self] events -> AnyPublisher<RecentComment?, Error> in
                guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                return events.publisher
                    .flatMap{ event in
                        return self.fetchResourceWithEvent(event:event)
                            .flatMap(self.fetchRecentCommentWithEvent(event: resource:))
                            .map{ recentComment -> RecentComment? in recentComment }
                            .replaceError(with: nil)
                            .setFailureType(to: Error.self)
                    }
                    .eraseToAnyPublisher()
            }
            .compactMap{ $0 }
            .collect()
            .map{ $0.sorted { $0.createdTime > $1.createdTime } }
            .eraseToAnyPublisher()
    }
}

private extension DefaultHomeUseCase {
    func fetchResourceWithEvent(event: CommentEvent) -> AnyPublisher<(CommentEvent, Resource), Error> {
        let components = event.eventPath.components(separatedBy: "/").filter{ !["","resources"].contains($0) }
        guard let first = components.first else  { return Fail(error: UseCaseError.noDataError).eraseToAnyPublisher() }
        return resourceRepository.fetchResource(resourceId: first)
            .map{ (event, $0) }
            .eraseToAnyPublisher()
    }
    
    func fetchRecentCommentWithEvent(event: CommentEvent, resource: Resource) -> AnyPublisher<RecentComment, Error> {
        return commentEventRepository.fetchCommentInfo(eventPath: event.eventPath)
            .flatMap(fetchUserWithComment(comment:))
            .map { RecentComment(user: $0, resource: resource, comment: $1, createdTime: event.eventTimestamp) }
            .eraseToAnyPublisher()
    }
    
    func fetchUserWithComment(comment: Comment) -> AnyPublisher<(User, Comment), Error> {
        return userRepository.fetchUser(uid: comment.authorUid)
            .map{ (user: $0, comment: comment) }
            .eraseToAnyPublisher()
    }
}
