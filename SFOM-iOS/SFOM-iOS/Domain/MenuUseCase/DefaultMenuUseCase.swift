//
//  DefaultMenuUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import Combine

final class DefaultMenuUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension DefaultMenuUseCase: MenuUseCase {
    func signOut() -> AnyPublisher<Bool, Error> {
        return authRepository.signOut()
    }
}
