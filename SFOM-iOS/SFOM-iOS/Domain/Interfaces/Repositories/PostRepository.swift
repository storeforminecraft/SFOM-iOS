//
//  PostRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/12.
//

import Combine

protocol PostRepository {
    func fetchPost() -> AnyPublisher<Post, Never>
}
