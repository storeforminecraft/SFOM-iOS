//
//  DatabaseReference+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine
import FirebaseDatabase

extension DatabaseReference {
    var getDataPublisher: AnyPublisher<DataSnapshot?, Never> {
        return Future<DataSnapshot?, Never> { [weak self] promise in
            guard let self = self else {
                promise(.success(nil))
                return
            }
            self.getData { error, dataSnapShot in
                if let error = error {
                    print("❎", error)
                    promise(.success(nil))
                }
                promise(.success(dataSnapShot))
            }
        }.eraseToAnyPublisher()
    }
}
