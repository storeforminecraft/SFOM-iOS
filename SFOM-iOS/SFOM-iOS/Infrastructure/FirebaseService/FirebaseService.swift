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
    }
}

private extension FirebaseService {
    func getRefence(endPoint: EndPoint){}
}

extension FirebaseService: NetworkService {
    func signIn(email: String, password: String) {

    }

    func signOut() {

    }
    
    func withdrawal() {
        
    }
    
    func create<T>(endPoint: EndPoint, dto: T) where T : DTO {
        
    }
    
    func read<T>(endPoint: EndPoint, dto: T) where T : DTO {
        
    }
    
    func update<T>(endPoint: EndPoint, dto: T) where T : DTO {
        
    }
    
    func delete<T>(endPoint: EndPoint, dto: T) where T : DTO {
        
    }
}
