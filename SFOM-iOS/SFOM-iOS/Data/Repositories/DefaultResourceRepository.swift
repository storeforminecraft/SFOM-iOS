//
//  DefaultResourceRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation
import Combine

final class DefaultResourceRepository {
    private let networkAuthService: NetworkAuthService
    private let networkService: NetworkService
    
    init(networkAuthService: NetworkAuthService, networkService: NetworkService) {
        self.networkAuthService = networkAuthService
        self.networkService = networkService
    }
}

extension DefaultResourceRepository: ResourceRepository {
    func fetchResource(resourceId: String) -> AnyPublisher<Resource, Error> {
        guard let endPoint = NetworkEndPoints.shared.resources(doc: resourceId) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.read(endPoint: endPoint, type: ResourceDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func fetchResourceComments(resourceId: String, limit: Int?) -> AnyPublisher<[Comment], Error> {
        guard let endPoint = NetworkEndPoints.shared.resourcesComments(doc: resourceId, subDoc: nil) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: CommentDTO.self,
                                                whereFields: [.isEqualTo("state", value: "published")],
                                                order: .descending("modifiedTimestamp"),
                                                limit: limit)
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
    
    func fetchResourceChildComment(resourceId: String, commentId: String) -> AnyPublisher<[Comment], Error> {
        guard let endPoint = NetworkEndPoints.shared.resourcesCommentsChildComment(doc: resourceId, subDoc: commentId) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: CommentDTO.self,
                                                whereFields: [.isEqualTo("state", value: "published")])
        .map { $0.map{ $0.toDomain() }.sorted { $0.modifiedTimestamp > $1.modifiedTimestamp } }
        .eraseToAnyPublisher()
    }
    
    func fetchUserResources(uid: String, limit: Int? = nil) -> AnyPublisher<[Resource], Error> {
        guard let endPoint = NetworkEndPoints.shared.resources(doc: nil) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: ResourceDTO.self,
                                                whereFields: [.isEqualTo("authorUid", value: uid)],
                                                order: .descending("modifiedTimestamp"),
                                                limit: limit)
        .map{ $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
    
    func fetchUserFavoriteResources(uid: String) -> AnyPublisher<[Resource], Error> {
        guard let endPoint = NetworkEndPoints.shared.favoritesResource() else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: FavoriteResourceDTO.self,
                                                whereFields: [.isEqualTo("pusherId", value: uid)])
        .flatMap { [weak self] favoriteResourceDTOs -> AnyPublisher<[ResourceDTO], Error> in
            guard let self = self else { return Fail(error: RepositoryError.noObjectError).eraseToAnyPublisher() }
            return favoriteResourceDTOs.publisher
                .flatMap { favoriteResourceDTO -> AnyPublisher<ResourceDTO?, Error> in
                    guard let endPoint = NetworkEndPoints.shared.resources(doc: favoriteResourceDTO.resourceId) else {
                        return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
                    }
                    return self.networkService.read(endPoint: endPoint, type: ResourceDTO.self)
                        .map{ resourceDTO -> ResourceDTO? in resourceDTO }
                        .replaceError(with: nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                .compactMap{ $0 }
                .collect()
                .eraseToAnyPublisher()
        }
        .map{ $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
    
    func fetchThumb(resourceId: String) -> AnyPublisher<ResourceThumb, Error> {
        guard let uid = networkAuthService.uid.value else {
            return Fail(error: RepositoryError.noAuthError).eraseToAnyPublisher()
        }
        guard let endPoint = NetworkEndPoints.shared.favoritesResource() else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: FavoriteResourceDTO.self,
                                                whereFields: [.isEqualTo("resourceId", value: resourceId)])
        .map { resources -> ResourceThumb in
            let isThumb = (resources.first(where: {$0.pusherId == uid}) != nil)
            return ResourceThumb(thumbCount: resources.count, isThumb: isThumb)
        }
        .eraseToAnyPublisher()
    }
    
    func pushThumb(category: String, resourceId: String) -> AnyPublisher<Bool, Error> {
        guard let uid = networkAuthService.uid.value else {
            return Fail(error: RepositoryError.noAuthError).eraseToAnyPublisher()
        }
        guard let endPoint = NetworkEndPoints.shared.favoritesResource(doc: resourceId) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        let createdTimestamp = Date()
        let dto = FavoriteResourceDTO(category: category,
                                      createdTime: Int(createdTimestamp.timeIntervalSince1970 * 1000),
                                      createdTimestamp: createdTimestamp,
                                      id: "\(uid)-\(resourceId)",
                                      pusherId: uid,
                                      resourceId: resourceId)
        return networkService.create(endPoint: endPoint, dto: dto)
            .map { _ -> Bool in true}
            .eraseToAnyPublisher()
    }
    
    func deleteThumb(resourceId: String) -> AnyPublisher<Bool, Error> {
        guard let endPoint = NetworkEndPoints.shared.favoritesResource(doc: resourceId) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.delete(endPoint: endPoint)
    }
}
