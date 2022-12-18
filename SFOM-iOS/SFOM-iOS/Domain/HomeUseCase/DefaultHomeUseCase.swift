//
//  DefaultPostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Combine

final class DefaultHomeUseCase {
    private let postRepository: PostRepository
    private let userRepository: UserRepository
    private let resourceRepository: ResourceRepository
    private let commentEventRepository: CommentEventRepository
    
    init(postRepository: PostRepository,
         userRepository: UserRepository,
         resourceRepository:ResourceRepository,
         commentEventRepository: CommentEventRepository) {
        self.postRepository = postRepository
        self.userRepository = userRepository
        self.resourceRepository = resourceRepository
        self.commentEventRepository = commentEventRepository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    func fetchCurrentUser() -> AnyPublisher<User, Error> {
        return userRepository.fetchCurrentUser()
    }
    
    func fetchPost() -> AnyPublisher<[Post], Error> {
        return postRepository.fetchPost()
    }
    
    func fetchRecentComment() -> AnyPublisher<[Comment], Error> {
        return commentEventRepository
            .fetchCommentEvent()
            .flatMap { events in
                return events.publisher
                    .flatMap { [weak self] event -> AnyPublisher<Comment, Error> in
                        guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
                        return self.commentEventRepository.fetchCommentInfo(eventPath: event.eventPath)
                    }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
