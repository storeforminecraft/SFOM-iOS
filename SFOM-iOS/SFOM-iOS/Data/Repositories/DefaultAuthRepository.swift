//
//  DefaultAuthRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Combine

final class DefaultAuthRepository {
    private let networkAuthService: NetworkAuthService
    
    init(networkAuthService: NetworkAuthService) {
        self.networkAuthService = networkAuthService
    }
}

extension DefaultAuthRepository: AuthRepository {
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Never> {
        networkAuthService.signIn(email: email, password: password)
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<Bool, Never> {
        return networkAuthService.signUp(email: email, password: password)
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Bool, Never> {
        networkAuthService.signOut()
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
    
    func withdrawal() -> AnyPublisher<Bool, Never>  {
        networkAuthService.withdrawal()
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}


