//
//  DefaultAuthUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import SwiftUI
import Combine

final class DefaultAuthUseCase {
    @AppStorage("User") var currentUser: User? = UserDefaults.standard.object(forKey: "User") as? User
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    private var cancellable = Set<AnyCancellable>()
    
    init(authRepository: AuthRepository, userRepository: UserRepository) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.bind()
    }
    
    func bind(){
        authRepository.uidChanges()
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
           .replaceError(with: nil)
           .sink(receiveValue: { user in
               self.currentUser = user
           })
           .store(in: &cancellable)
    }
}

extension DefaultAuthUseCase: AuthUseCase {
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

