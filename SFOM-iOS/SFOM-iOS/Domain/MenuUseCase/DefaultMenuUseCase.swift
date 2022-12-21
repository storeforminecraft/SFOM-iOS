//
//  DefaultMenuUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import Combine

final class DefaultMenuUseCase {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    init( authRepository: AuthRepository, userRepository: UserRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
}

extension DefaultMenuUseCase: MenuUseCase {
    func fetchCurrentUserWithUidChanges() -> AnyPublisher<User?, Error> {
        return authRepository.uidChanges()
            .flatMap { uid -> AnyPublisher<User?, Error> in
                if uid != nil {
                    return self.userRepository.fetchCurrentUser()
                        .map { user -> User? in user }
                        .eraseToAnyPublisher()
                } else {
                    return Just<User?>(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Bool, Error> {
        return authRepository.signOut()
    }
}
