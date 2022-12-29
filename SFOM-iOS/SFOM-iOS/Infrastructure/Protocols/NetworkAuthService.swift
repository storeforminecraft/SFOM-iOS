//
//  NetworkAuthService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import Combine

protocol NetworkAuthService {
    var uid: CurrentValueSubject<String?, Never> { get }
    
    func signIn(email: String, password: String) -> AnyPublisher<String?, Error>
    func signUp(email: String, password: String) -> AnyPublisher<String?, Error>
    func signOut() -> AnyPublisher<Bool, Error>
}
