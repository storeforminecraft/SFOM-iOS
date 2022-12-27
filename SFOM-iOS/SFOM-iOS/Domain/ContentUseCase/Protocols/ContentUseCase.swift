//
//  ContentUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/21.
//

import Combine

protocol ContentUseCase {
    func fetchCurrentUserWithUidChanges() -> AnyPublisher<User?, Error> 
    func fetchUser(uid: String) -> AnyPublisher<User, Error>
    func fetchUserComment(resourceId: String) -> AnyPublisher<[UserComment], Error>
    func fetchUserResources(uid: String) -> AnyPublisher<[Resource], Error>
}
