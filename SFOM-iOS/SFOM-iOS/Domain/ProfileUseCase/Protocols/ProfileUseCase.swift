//
//  ProfileUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/02.
//

import Combine

protocol ProfileUseCase {
    func fetchCurrentUserWithUidChanges() -> AnyPublisher<User?, Error>
    func fetchUser(uid: String) ->  AnyPublisher<User, Error>
    func fetchUserResources(uid: String) -> AnyPublisher<[Resource], Error>
}
