//
//  DocumentReference+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Firebase
import Combine

extension DocumentReference {
    func getDocumentPublisher<T: Decodable>(type: T.Type) -> AnyPublisher<T?, Never> {
        Future<T?, Never> { [weak self] promise in
            guard let self = self else {
                promise(.success(nil))
                return
            }
            self.getDocument(as: T.self) { data in
                promise(.success(try? data.get()))
            }
        }.eraseToAnyPublisher()
    }

    var getDocumentPublisher: AnyPublisher<[String: Any]?, Never> {
        return Future<[String: Any]?, Never> { [weak self] promise in
            guard let self = self else {
                promise(.success(nil))
                return
            }
            self.getDocument { snapshotData, error in
                promise(.success(snapshotData?.data()))
            }
        }.eraseToAnyPublisher()
    }
}
