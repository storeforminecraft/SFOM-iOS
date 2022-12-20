//
//  ContentUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/21.
//

import Combine

protocol ContentUseCase {
    func fetchUser(uid: String) -> AnyPublisher<User, Error>
    func fetchComment(resourceId: String) -> AnyPublisher<[Comment], Error>
    func fetchUserResources(uid: String) -> AnyPublisher<[Resource], Error>
}
