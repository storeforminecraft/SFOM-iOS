//
//  PostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Combine

protocol PostUseCase {
    func fetchPost() -> AnyPublisher<[Post], Never>
}
