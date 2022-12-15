//
//  Query+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/15.
//

import Firebase
import Combine

extension Query {
    // MARK: - READ
    func getQueryDocumentsPublisher<T: Decodable>(type: T.Type) -> AnyPublisher<[T], Error> {
        Future<[T], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getDocuments { querySnapshot, error in
                if let error = error {
                    promise(.failure(error))
                }
                guard let querySnapshot = querySnapshot else { return }
                let data = querySnapshot.documents.compactMap { docunment in
                    try? docunment.data(as: type)
                }
                promise(.success(data))
            }
        }.eraseToAnyPublisher()
    }
    
    func getQueryDocumentsPublisher() -> AnyPublisher<QuerySnapshot, Error> {
        Future<QuerySnapshot, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getDocuments { querySnapshot, error in
                if let error = error {
                    promise(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    promise(.failure(FirebaseCombineError.noDataError))
                    return
                }
                promise(.success(querySnapshot))
            }
        }.eraseToAnyPublisher()
    }
}
