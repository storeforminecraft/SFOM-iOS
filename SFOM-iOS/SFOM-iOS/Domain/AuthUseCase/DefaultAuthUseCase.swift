//
//  DefaultAuthUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

final class DefaultAuthUseCase {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    init(authRepository: AuthRepository, userRepository: UserRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
}

extension DefaultAuthUseCase: AuthUseCase {
    func uidChanges() -> AnyPublisher<String?, Never> {
        return authRepository.uidChanges()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return authRepository.signIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String, userName: String) -> AnyPublisher<Bool, Error> {
        return authRepository.signUp(email: email, password: password, userName: userName)
    }

    func signOut() -> AnyPublisher<Bool, Error> {
        return authRepository.signOut()
    }
    
    func resetPassword(email: String) -> AnyPublisher<Bool, Error> {
        return authRepository.resetPassword(email: email)
    }
}

extension DefaultAuthUseCase: ProtectedAuthUseCase {
    func withdrawal() -> AnyPublisher<Bool, Error> {
        guard let authRepository = authRepository as? ProtectedAuthRepository else {
            return Fail(error: RepositoryError.castingError).eraseToAnyPublisher()
        }
        return authRepository.withdrwal()
    }
}

