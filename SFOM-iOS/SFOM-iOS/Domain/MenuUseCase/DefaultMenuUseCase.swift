//
//  DefaultMenuUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import Combine

final class DefaultMenuUseCase {
    private let userRepository: UserRepository
    private let authRepository: AuthRepository
    
    init(userRepository: UserRepository, authRepository: AuthRepository) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
    
}

extension DefaultMenuUseCase: MenuUseCase {
    func fetchCurrentUser() -> AnyPublisher<User, Error> {
        return userRepository.fetchCurrentUser()
    }
    
    func signOut() -> AnyPublisher<Bool, Error> {
        return authRepository.signOut()
    }
}
