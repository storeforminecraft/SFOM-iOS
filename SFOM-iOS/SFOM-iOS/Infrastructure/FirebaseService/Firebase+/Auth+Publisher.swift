//
//  FirebaseAuth+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import FirebaseAuth
import Combine

extension Auth {
    func signInPublisher(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error>{ [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let authResult = authResult else {
                    promise(.failure(FirebaseCombineError.noDataError))
                    return 
                }
                promise(.success(authResult))
            }
        }.eraseToAnyPublisher()
    }
    
    func signOutPublisher() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            do {
                try self.signOut()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func withdrawalPublisher() -> AnyPublisher<Bool,Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.currentUser?.delete(completion: { error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                promise(.success(true))
            })
        }.eraseToAnyPublisher()
    }
}
