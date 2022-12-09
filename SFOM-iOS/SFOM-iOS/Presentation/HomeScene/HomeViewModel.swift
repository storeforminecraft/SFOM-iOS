//
//  HomeViewModel.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Foundation

final class HomeViewModel: ViewModel {
    @Published var posts: [Post] = []
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        FirebaseService.shared.firestore.collection("posts")
            .whereField("state", isEqualTo: "published")
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error { print(error) }
                guard let querySnapshot = querySnapshot else { return }
                self?.posts = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: Post.self)
                }
            }
    }
}
