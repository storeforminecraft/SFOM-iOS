//
//  DatabaseReference+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine
import FirebaseDatabase

extension DatabaseReference {
    // MARK: - READ
    var getDataPublisher: AnyPublisher<DataSnapshot, Error> {
        return Future<DataSnapshot, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getData { error, dataSnapShot in
                if let error = error {
                    promise(.failure(error))
                }
                guard let dataSnapShot = dataSnapShot else {
                    return promise(.failure(FirebaseCombineError.noDataError))
                }
                promise(.success(dataSnapShot))
            }
        }.eraseToAnyPublisher()
    }
}
