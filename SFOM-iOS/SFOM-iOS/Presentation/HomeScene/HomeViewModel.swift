//
//  HomeViewModel.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import Combine

final class HomeViewModel: ViewModel {
    @Published var posts: [Post] = []
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchPosts()
        print("----")
        FirebaseService.shared.saltPassword(email: "x", password: "x")
            .sink { a in
                print(a)
            }
            .store(in: &cancellable)
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
