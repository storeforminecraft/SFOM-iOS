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
    var ref: DatabaseReference

    private init() {
        FirebaseApp.configure()
        auth = Auth.auth()
        firestore = Firestore.firestore()

        let db = Database.database()
        db.isPersistenceEnabled = true
        ref = db.reference(fromURL: "https://storeforminecraft.firebaseio.com")
        ref.keepSynced(true)
    }
}

private extension FirebaseService {
    
}

extension FirebaseService: NetworkService {
    func signIn(email: String, password: String) {

    }

    func signOut() {

    }

    func creat() {

    }

    func read() {

    }

    func update() {

    }

    func delete() {

    }
}
