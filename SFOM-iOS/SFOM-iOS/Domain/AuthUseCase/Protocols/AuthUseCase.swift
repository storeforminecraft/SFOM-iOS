//
//  AuthUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

protocol AuthUseCase {
    func uidChanges() -> AnyPublisher<String?, Never>
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Error>
    func signUp(email: String, password: String, userName: String) -> AnyPublisher<Bool, Error>
    func signOut() -> AnyPublisher<Bool, Error>
    func resetPassword(email: String) -> AnyPublisher<Bool, Error>
}
