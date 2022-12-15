//
//  FirebaseAuth+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import FirebaseAuth
import Combine

extension Auth {
    // MARK: - Sign In
    func signInPublisher(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error>{ [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                } else {
                    promise(.failure(FirebaseCombineError.noDataError))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Sign Up
    func signUpPublisher(email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.createUser(withEmail: email, password: password) { authDataResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authDataResult = authDataResult {
                    promise(.success(authDataResult))
                } else {
                    promise(.failure(FirebaseCombineError.noDataError))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Sign Out
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
    
    // MARK: - Withdrawal
    func withdrawalPublisher() -> AnyPublisher<Bool,Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.currentUser?.delete(completion: { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            })
        }.eraseToAnyPublisher()
    }
}
