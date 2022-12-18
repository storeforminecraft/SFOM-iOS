//
//  FirebaseManager.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/25.
//

import Combine
import CryptoKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Configure
final class FirebaseService {
    static let shared = FirebaseService()
    
    private let auth: Auth
    private let firestore: Firestore
    private let reference: DatabaseReference
    
    let uid = CurrentValueSubject<String?, Never>(nil)
    
    private init() {
        FirebaseApp.configure()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        let database = Database.database()
        database.isPersistenceEnabled = true
        let databaseURL = URLStringManager.urlString(key: .firebaseDatabaseURL)
        reference = database.reference(fromURL: databaseURL)
        reference.keepSynced(true)
        
        uid.send(auth.currentUser?.uid)
    }
}

// MARK: - NetworkAuthService
extension FirebaseService: NetworkAuthService {
    func signIn(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return self.saltPassword(email: email, password: password)
            .flatMap { [weak self] password -> AnyPublisher<Bool,Error> in
                guard let self = self else { return Fail<Bool, Error>(error: FirebaseCombineError.noDataError).eraseToAnyPublisher() }
                guard let password = password else {
                    return Just<Bool>(false)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.auth.signInPublisher(email: email, password: password)
                    .map { _ in true }
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }
                self.uid.send(self.auth.currentUser?.uid)
            })
            .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<Bool, Error> {
        return self.saltPassword(email: email, password: password)
            .flatMap { [weak self] password -> AnyPublisher<Bool,Error> in
                guard let self = self else { return Fail<Bool, Error>(error: FirebaseCombineError.noDataError).eraseToAnyPublisher() }
                guard let password = password else {
                    return Just<Bool>(false)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.auth.signUpPublisher(email: email, password: password)
                    .map { _ in true }
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }
                self.uid.send(self.auth.currentUser?.uid)
            })
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Bool, Error> {
        return self.auth.signOutPublisher()
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }
                self.uid.send(self.auth.currentUser?.uid)
            })
            .eraseToAnyPublisher()
    }
    
    func withdrawal() -> AnyPublisher<Bool, Error> {
        return self.auth.withdrawalPublisher()
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }
                self.uid.send(self.auth.currentUser?.uid)
            })
            .eraseToAnyPublisher()
    }
}

// MARK: - NetworkService
extension FirebaseService: NetworkService {
    func create<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error> {
        guard let documentReference = documentReference(endPoint: endPoint) else {
            return Fail(error: FirebaseCombineError.wrongAccessError).eraseToAnyPublisher()
        }
        return documentReference.setDataPulisher(data: dto)
    }
    
    func read<T: Decodable>(endPoint: FIREndPoint, type: T.Type) -> AnyPublisher<T, Error> {
        guard let documentReference = documentReference(endPoint: endPoint) else {
            return Fail(error: FirebaseCombineError.wrongAccessError).eraseToAnyPublisher()
        }
        return documentReference.getDocumentPublisher(type: type)
    }
    
    func update<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error> {
        guard let documentReference = documentReference(endPoint: endPoint) else {
            return Fail<T, Error>(error: FirebaseCombineError.wrongAccessError).eraseToAnyPublisher()
        }
        return documentReference.setDataPulisher(data: dto, merge: true)
    }
    
    func delete<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error> {
        guard let documentReference = documentReference(endPoint: endPoint) else {
            return Fail(error: FirebaseCombineError.wrongAccessError).eraseToAnyPublisher()
        }
        return documentReference.deletePublisher()
            .map{ _ in dto }
            .eraseToAnyPublisher()
    }
    
    func readAll<T: Decodable>(endPoint: FIREndPoint, type: T.Type) -> AnyPublisher<[T], Error> {
        guard let collectionReference = collectionReference(endPoint: endPoint) else {
            return Fail(error: FirebaseCombineError.wrongAccessError).eraseToAnyPublisher()
        }
        return collectionReference.getDocumentsPublisher(type: type)
    }
    
    func readAllWithFilter<T: Decodable>(endPoint: FIREndPoint, type: T.Type, whereFields: [WhereField]?, order: Order?, limit: Int? = nil) -> AnyPublisher<[T], Error> {
        guard var collectionReference = (collectionReference(endPoint: endPoint)) as Query? else {
            return Fail(error: FirebaseCombineError.wrongAccessError).eraseToAnyPublisher()
        }
        if let whereFields = whereFields { collectionReference = collectionReference.filter(whereFields) }
        if let limit = limit { collectionReference = collectionReference.limit(to: limit) }
        if let order = order { collectionReference = collectionReference.order(order) }
        return collectionReference.getQueryDocumentsPublisher(type: type)
    }
}

// MARK: - Reference
private extension FirebaseService {
    func documentReference<E: FIREndPoint>(endPoint: E) -> DocumentReference? {
        let collectionPath = endPoint.reference.collection.path
        guard let documet = endPoint.reference.document,
              let documnetPath = (documet.isCurrentUser ? uid.value : documet.path) else { return nil }
        
        guard let subCollectionPath = endPoint.reference.subCollection?.path else {
            return firestore
                .collection(collectionPath)
                .document(documnetPath)
        }
        guard let subDocumet = endPoint.reference.subDocument,
              let subDocumnetPath = (documet.isCurrentUser ? uid.value : subDocumet.path) else { return nil }
        
        return firestore
            .collection(collectionPath)
            .document(documnetPath)
            .collection(subCollectionPath)
            .document(subDocumnetPath)
    }
    
    func collectionReference<E: FIREndPoint>(endPoint: E) -> CollectionReference? {
        let collectionPath = endPoint.reference.collection.path
        guard let documet = endPoint.reference.document,
              let documnetPath = (documet.isCurrentUser ? uid.value : documet.path) else { return
            firestore.collection(collectionPath)
        }
        
        guard let subCollectionPath = endPoint.reference.subCollection?.path else {
            return firestore.collection(collectionPath)
        }
        
        return firestore
            .collection(collectionPath)
            .document(documnetPath)
            .collection(subCollectionPath)
    }
}


// MARK: - Secure
private extension FirebaseService {
    func saltPassword(email: String, password: String) -> AnyPublisher<String?, Error> {
        guard let emailData = email.data(using: .utf8) else {
            return  Fail(error: FirebaseCombineError.noDataError).eraseToAnyPublisher()
        }
        let child = SHA256.hash(data: emailData).compactMap { String(format: "%02x", $0) }.joined()
        
        return self.reference.child("salts")
            .child(child)
            .getDataPublisher
            .timeout(.seconds(5), scheduler: DispatchQueue.global())
            .catch { _ in Fail(error: FirebaseCombineError.noDataError).eraseToAnyPublisher() }
            .map { [weak self] dataSnapshot -> String? in
                guard let self = self else { return nil }
                guard let dataSnapshotValue = dataSnapshot.value else { return nil }
                
                var salt = ""
                if dataSnapshot.value! is NSNull {
                    guard let sha1Email = self.sha1Hash(data: emailData).lastWord else { return nil }
                    salt = String(sha1Email.prefix(5))
                } else {
                    guard let salt2 = (dataSnapshotValue as? NSDictionary)?["salt"] as? String else { return nil }
                    salt = salt2
                }
                
                guard let firstHashingData = "MCPE STORE\(password)ver2".data(using: .utf8) else { return nil }
                guard let firstHashing = self.sha1Hash(data: firstHashingData).lastWord else { return nil }
                guard let secondHashingData = "\(salt)\(firstHashing)MCPE_STORE_ver2".data(using: .utf8) else { return nil }
                guard let secondHashing = self.sha2Hash(data: secondHashingData).lastWord else { return nil }
                return secondHashing
            }
            .eraseToAnyPublisher()
    }
    
    func sha1Hash(data: Data) -> String {
        return Insecure.SHA1.hash(data: data).description
    }
    
    func sha2Hash(data: Data) -> String {
        return SHA512.hash(data: data).description
    }
}
