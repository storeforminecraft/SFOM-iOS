//
//  DocumentReference+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Firebase
import Combine

extension DocumentReference {
    // MARK: - CREATE, UPDATE
    func setDataPulisher<T: Encodable>(data: T, merge: Bool = false) -> AnyPublisher<T, Error> {
        Future<T, Error> { [weak self] promise in
            do {
                guard let self = self else { throw FirebaseCombineError.objectError }
                try self.setData(from: data, merge: merge)
                promise(.success(data))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - READ
    func getDocumentPublisher<T: Decodable>(type: T.Type) -> AnyPublisher<T, Error> {
        Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getDocument(as: T.self) { data in
                guard let data = try? data.get() else {
                    promise(.failure(FirebaseCombineError.noDataError))
                    return
                }
                promise(.success(data))
            }
        }.eraseToAnyPublisher()
    }
    
    var getDocumentPublisher: AnyPublisher<[String: Any], Error> {
        Future<[String: Any], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getDocument { snapshotData, error in
                guard let data = snapshotData?.data() else {
                    promise(.failure(FirebaseCombineError.noDataError))
                    return
                }
                promise(.success(data))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - DELETE
    func deletePublisher() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { [weak self] promise in
            self?.delete{ error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
}
