//
//  DocumentReference+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Firebase
import Combine

extension DocumentReference {
    func getDocumentPublisher<T: Decodable>(type: T.Type) -> AnyPublisher<T?, Error> {
        Future<T?, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getDocument(as: T.self) { data in
                promise(.success(try? data.get()))
            }
        }.eraseToAnyPublisher()
    }
    
    var getDocumentPublisher: AnyPublisher<[String: Any]?, Error> {
        return Future<[String: Any]?, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getDocument { snapshotData, error in
                promise(.success(snapshotData?.data()))
            }
        }.eraseToAnyPublisher()
    }
    
    func setDataPulisher<T: Encodable>(data: T) -> AnyPublisher<T?, Error> {
        Future<T?, Error> { [weak self] promise in
            do {
                guard let self = self else { throw FirebaseCombineError.objectError }
                try self.setData(from: data)
                promise(.success(data))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
