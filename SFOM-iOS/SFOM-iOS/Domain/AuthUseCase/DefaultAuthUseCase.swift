//
//  DefaultAuthUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

final class DefaultAuthUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension DefaultAuthUseCase: AuthUseCase {
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return authRepository.signIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return authRepository.signUp(email: email, password: password)
    }

    func signOut() -> AnyPublisher<Bool, Error> {
        return authRepository.signOut()
    }
}

extension DefaultAuthUseCase: ProtectedAuthUseCase {
    func withdrawal() -> AnyPublisher<Bool, Error> {
        guard let authRepository = authRepository as? ProtectedAuthRepository else { return Just(false).eraseToAnyPublisher() }
        return authRepository.withdrwal()
    }
}

