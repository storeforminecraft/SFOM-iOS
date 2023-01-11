//
//  DatabaseReference+Publisher.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine
import FirebaseDatabase

extension DatabaseReference {
    typealias DatabaseValue = [String: Any?]
    
    // MARK: - CREATE, UPDATE, DELETE
    func updateChildValuesPublisher(value: DatabaseValue) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.updateChildValues(value as [AnyHashable : Any]) { error, databaseReference in
                do {
                    if let error = error { throw error }
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - READ
    func getDataPublisher() -> AnyPublisher<DatabaseValue?, Error> {
        return Future<DatabaseValue?, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.getData { error, dataSnapshot in
                do {
                    if let error = error { throw error }
                    guard let dataSnapshot = dataSnapshot else { throw FirebaseCombineError.noDataError }
                    guard let databaseValue = dataSnapshot.value as? DatabaseValue else {
                        promise(.success(nil))
                        return
                    }
                    promise(.success(databaseValue))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func observeSingleEventPublisher() -> AnyPublisher<DatabaseValue?, Error> {
        return Future<DatabaseValue?, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(FirebaseCombineError.objectError))
                return
            }
            self.observeSingleEvent(of: .value) { dataSnapshot in
                guard let databaseValue = dataSnapshot.value as? DatabaseValue else {
                    promise(.success(nil))
                    return
                }
                promise(.success(databaseValue))
            }
        }.eraseToAnyPublisher()
    }
}
