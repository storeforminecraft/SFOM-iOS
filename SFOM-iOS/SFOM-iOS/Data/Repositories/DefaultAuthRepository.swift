//
//  DefaultAuthRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Combine
import UIKit

final class DefaultAuthRepository {
    private let networkAuthService: NetworkAuthService
    private let databaseService: DatabaseService
    private let httpService: HTTPService
    
    init(networkAuthService: NetworkAuthService, databaseService: DatabaseService, httpService: HTTPService) {
        self.networkAuthService = networkAuthService
        self.databaseService = databaseService
        self.httpService = httpService
    }
}

extension DefaultAuthRepository: AuthRepository {
    func uidChanges() -> AnyPublisher<String?, Never> {
        return networkAuthService.uid.eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return networkAuthService.signIn(email: email, password: password)
            .flatMap{ [weak self] uid -> AnyPublisher<Bool, Error> in
                guard let self = self else { return Fail(error: RepositoryError.noObjectError).eraseToAnyPublisher() }
                guard let uid = uid else { return Fail(error: RepositoryError.noAuthError).eraseToAnyPublisher() }
                let endPoint = DatabaseEndPoints.shared.user(uid: uid)
                let databaseValue = DatabaseUser(handles: [.set(.lastSignInDeviceId(UIDevice.current.identifierForVendor!.uuidString)),
                                                           .set(.lastSignInTime(Date())),
                                                           // .delete(.language())
                ]).values
                return self.databaseService.setValue(endPoint: endPoint, value: databaseValue)
            }
            .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String, userName: String) -> AnyPublisher<Bool, Error> {
        return networkAuthService.signUp(email: email, password: password)
            .flatMap{ [weak self] uid -> AnyPublisher<Bool, Error> in
                guard let self = self else { return Fail(error: RepositoryError.noObjectError).eraseToAnyPublisher() }
                guard let uid = uid else { return Fail(error: RepositoryError.noAuthError).eraseToAnyPublisher() }
                let endPoint = DatabaseEndPoints.shared.user(uid: uid)
                let databaseValue = DatabaseUser(handles: [.set(.email(email)),
                                                           .set(.lastSignInDeviceId(UIDevice.current.identifierForVendor!.uuidString)),
                                                           .set(.lastSignInTime(Date())),
                                                           .set(.language(StringCollection.location)),
                                                           .set(.nickname(userName)),
                                                           .set(.profileImage("")),
                                                           .set(.uid(uid))]).values
                return self.databaseService.setValue(endPoint: endPoint, value: databaseValue)
            }
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Bool, Error> {
        return networkAuthService.signOut()
    }
    
    func withdrawal() -> AnyPublisher<Bool, Error>  {
        guard let uid = networkAuthService.uid.value else { return Fail(error: RepositoryError.noObjectError).eraseToAnyPublisher() }
        let endPoint = HTTPEndPoints.shared.withdrawal(uid: uid)
        return httpService.dataTaskPublisher(endPoint: endPoint)
    }
    
    func resetPassword(email: String) -> AnyPublisher<Bool, Error> {
        let endPoint = HTTPEndPoints.shared.resetPassword(email: email)
        return httpService.dataTaskPublisher(endPoint: endPoint)
    }
}


