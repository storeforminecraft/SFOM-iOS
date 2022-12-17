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
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return networkAuthService.signIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return networkAuthService.signUp(email: email, password: password)
    }
    
    func signOut() -> AnyPublisher<Bool, Error> {
        return networkAuthService.signOut()
    }
    
    func withdrawal() -> AnyPublisher<Bool, Error>  {
        return networkAuthService.withdrawal()
    }
}


