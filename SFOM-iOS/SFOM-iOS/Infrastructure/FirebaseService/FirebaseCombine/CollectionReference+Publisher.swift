//
//  CollectionReference.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import Firebase
import FirebaseFirestoreSwift
import Combine

extension CollectionReference {
    // MARK: - CREATE
    func addDocumentPublisher<D: Encodable>(data: D) -> AnyPublisher<DocumentReference, Error> {
        Future<DocumentReference, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            do {
                let documentReference = try self.addDocument(from: data)
                promise(.success(documentReference))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func addDocumentPublisher(data: [String: Any]) -> AnyPublisher<DocumentReference, Error> {
        Future<DocumentReference, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            let documentReference = self.addDocument(data:data)
            promise(.success(documentReference))
        }.eraseToAnyPublisher()
    }
    
    // MARK: - READ
    func getDocumentsPublisher<T: Decodable>(type: T.Type) -> AnyPublisher<[T], Error> {
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
    
    func getDocumentsPublisher() -> AnyPublisher<QuerySnapshot, Error> {
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
