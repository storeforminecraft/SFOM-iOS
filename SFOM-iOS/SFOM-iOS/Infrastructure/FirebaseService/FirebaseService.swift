//
//  FirebaseManager.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/25.
//

import Combine
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseService {
    static let shared = FirebaseService()
    let uid = CurrentValueSubject<String?, Never>(nil)
    let auth: Auth
    let firestore: Firestore
    var reference: DatabaseReference
    
    private init() {
        FirebaseApp.configure()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        let database = Database.database()
        database.isPersistenceEnabled = true
        reference = database.reference(fromURL: "https://storeforminecraft.firebaseio.com")
        reference.keepSynced(true)
        
        uid.send(auth.currentUser?.uid)
    }
}

private extension FirebaseService {
    func documentReference<E: EndPoint>(endPoint: E) -> DocumentReference? {
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
    
    func collectionReference<E: EndPoint>(endPoint: E) -> CollectionReference? {
        let collectionPath = endPoint.reference.collection.path
        guard let documet = endPoint.reference.document,
              let documnetPath = (documet.isCurrentUser ? uid.value : documet.path) else { return nil }
        
        guard let subCollectionPath = endPoint.reference.subCollection?.path else {
            return firestore
                .collection(collectionPath)
        }
        
        return firestore
            .collection(collectionPath)
            .document(documnetPath)
            .collection(subCollectionPath)
    }
}

extension FirebaseService: NetworkService {
    func signIn(email: String, password: String){
        // self.saltPassword(email: email, password: password)

        
        // auth.signIn(withEmail: email, password: password, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
    }
    
    func signOut() {
        auth.signOut()
    }
    
    func withdrawal() {
        
    }
    
    func create<T>(endPoint: EndPoint, dto: T) where T: DTO {
        
    }
    
    func read<T>(endPoint: EndPoint, dto: T) where T: DTO {
        
    }
    
    func update<T>(endPoint: EndPoint, dto: T) where T: DTO {
        
    }
    
    func delete<T>(endPoint: EndPoint, dto: T) where T: DTO {
        
    }
}
