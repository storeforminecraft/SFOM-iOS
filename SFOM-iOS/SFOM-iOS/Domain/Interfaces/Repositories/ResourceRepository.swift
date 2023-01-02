//
//  ResourceRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Combine

protocol ResourceRepository {
    func fetchResource(resourceId: String) -> AnyPublisher<Resource, Error>
    func fetchResourceComments(resourceId: String) -> AnyPublisher<[Comment], Error>
    func fetchUserResources(uid: String, limit: Int?) -> AnyPublisher<[Resource], Error>
    func fetchUserFavoriteResources(uid: String) -> AnyPublisher<[Resource], Error>
}
