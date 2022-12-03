//
//  Firebase+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/03.
//

import Foundation
import Firebase
import Combine

extension DocumentReference {
    func publisher<T: Decodable>(type: T.Type) -> AnyPublisher<T?, Never> {
        Future<T?, Never> { promise in
            self.getDocument(as: T.self) { data in
                promise(.success(try? data.get()))
            }
        }.eraseToAnyPublisher()
    }

    var publisher: AnyPublisher<[String: Any]?, Never> {
        return Future<[String: Any]?, Never> { promise in
            self.getDocument { snapshotData, error in
                if let data = snapshotData?.data() {
                    promise(.success(data))
                } else {
                    promise(.success(nil))
                }
            }
        }.eraseToAnyPublisher()
    }
}
