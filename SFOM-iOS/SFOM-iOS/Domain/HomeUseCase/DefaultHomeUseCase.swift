//
//  DefaultPostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Combine

final class DefaultHomeUseCase {
    private let postRepository: PostRepository
    private let ResourceRepository: ResourceRepository
    private let commentEventRepository: CommentEventRepository
    
    init(postRepository: PostRepository, commentEventRepository: CommentEventRepository) {
        self.postRepository = postRepository
        self.commentEventRepository = commentEventRepository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    func fetchPost() -> AnyPublisher<[Post], Error> {
        return postRepository.fetchPost()
    }
    
    func fetchRecentComment() -> AnyPublisher<[Comment], Error> { 
        return commentEventRepository.fetchCommentInfo(eventPath: "/resources/ecc5a9fb-beb8-4289-a2ef-e9db47f538d1/comments/edcb3149-f685-4b47-9a5a-81834918fea4")
            .map { comment -> [Comment] in return [comment]}
            .eraseToAnyPublisher()
    }
}
