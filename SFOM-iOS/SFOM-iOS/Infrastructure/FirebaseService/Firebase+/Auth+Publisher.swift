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
                promise(.failure(SFOMError.objectError))
                return
            }
            self.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let authResult = authResult else {
                    promise(.failure(SFOMError.noDataError))
                    return 
                }
                promise(.success(authResult))
            }
        }.eraseToAnyPublisher()
    }
}
