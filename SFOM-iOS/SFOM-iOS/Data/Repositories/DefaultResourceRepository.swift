//
//  DefaultResourceRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Combine

final class DefaultResourceRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
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
    
    func fetchResourceComments(resourceId: String) -> AnyPublisher<[Comment], Error> {
        guard let endPoint = NetworkEndPoints.shared.resourcesComments(doc: resourceId, subDoc: nil) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: CommentDTO.self,
                                                whereFields: [.isEqualTo("state", value: "published")],
                                                order: .descending("createdTimestamp"),
                                                limit: nil)
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
    
    func fetchUserResources(uid: String, limit: Int? = nil) -> AnyPublisher<[Resource], Error> {
        guard let endPoint = NetworkEndPoints.shared.resources(doc: nil) else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: ResourceDTO.self,
                                                whereFields: [.isEqualTo("authorUid", value: uid)],
                                                order: .descending("createdTimestamp"),
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
                                                whereFields: [.isEqualTo("pusherId", value: uid)],
                                                order: nil,
                                                limit: nil)
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
}
