//
//  UserRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Combine

protocol UserRepository {
    func fetchCurrentUser() -> AnyPublisher<User, Error>
    func fetchUser(uid: String) -> AnyPublisher<User, Error>
}
