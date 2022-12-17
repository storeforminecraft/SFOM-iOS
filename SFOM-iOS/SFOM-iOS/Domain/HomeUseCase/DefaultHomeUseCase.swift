//
//  DefaultPostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Combine

final class DefaultHomeUseCase {
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    func fetchPost() -> AnyPublisher<[Post], Never> {
        postRepository.fetchPost()
    }
}
