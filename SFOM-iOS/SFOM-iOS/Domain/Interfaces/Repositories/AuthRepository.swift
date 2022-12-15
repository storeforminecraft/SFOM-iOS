//
//  AuthRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

protocol AuthRepository {
    func signIn() -> AnyPublisher<Bool, Never>
    func signOut() -> AnyPublisher<Bool, Never>
}

protocol ProtectedAuthRepository {
    func withdrwal() -> AnyPublisher<Bool, Never>
}
