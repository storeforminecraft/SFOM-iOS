//
//  DefaultUserRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Combine

final class DefaultUserRepository {
    private let networkAuthService: NetworkAuthService
    private let httpService: HTTPService
    
    init(networkAuthService: NetworkAuthService,
         DatabaseService: DatabaseService,
         httpService: HTTPService) {
        self.networkAuthService = networkAuthService
        self.httpService = httpService
    }
}

extension DefaultUserRepository: UserRepository {
    func fetchCurrentUser() -> AnyPublisher<User, Error> {
        guard let uid = networkAuthService.uid.value else { return Fail(error: RepositoryError.noAuthError).eraseToAnyPublisher() }
        let httpEndPoint = HTTPEndPoints.shared.userProfile(uid: uid)
        return httpService.dataTaskPublisher(endPoint: httpEndPoint, type: UserDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func fetchUser(uid: String) -> AnyPublisher<User, Error> {
        let httpEndPoint = HTTPEndPoints.shared.userProfile(uid: uid)
        return httpService.dataTaskPublisher(endPoint: httpEndPoint, type: UserDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
