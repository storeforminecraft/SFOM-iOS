//
//  PostUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/30.
//

import Combine

protocol PostUseCase {
    func fetchUser(uid: String) ->  AnyPublisher<User, Error>
    func fetchResources(resourceIds: [String]) -> AnyPublisher<[Resource], Error>
}


