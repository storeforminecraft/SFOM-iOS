//
//  PostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Combine

protocol HomeUseCase {
    func fetchCurrentUserWithUidChanges() -> AnyPublisher<User?, Error>
    func fetchPost() -> AnyPublisher<[Post], Error>
    func fetchRecentComment() -> AnyPublisher<[RecentComment], Error>
}
