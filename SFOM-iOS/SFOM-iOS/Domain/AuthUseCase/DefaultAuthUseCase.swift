//
//  DefaultAuthUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

final class DefaultAuthUseCase {
    
}

extension DefaultAuthUseCase: AuthUseCase {
    func signIn() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            promise(.success(true))
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { Promise in
            Promise(.success(true))
        }.eraseToAnyPublisher()
    }
}
