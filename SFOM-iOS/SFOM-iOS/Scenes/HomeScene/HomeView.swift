//
//  HomeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI

fileprivate final class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []

    init() {
        fetchPosts()
    }

    func fetchPosts() {
        FirebaseManager.shared.firestore.collection("posts")
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

struct HomeView: View {
    @EnvironmentObject var sharedData: SharedData
    @ObservedObject private var homeViewModel = HomeViewModel()

    var body: some View {
        VStack (alignment: .leading) {
            homeNavigationBar
            ScrollView {
                postItemsView
            }

        }
    }

    private var homeNavigationBar: some View {
        HStack(alignment: .center) {
            Text(LocalizedString.homeTitle)
                .font(.SFOMTitleFont)
            Spacer()
            // NavigationLink {
            //     // FIXME: - Push View
            // } label: {
            //     ZStack (alignment: .topTrailing) {
            //         Assets.moreMenu.push.image
            //             .resizable()
            //             .frame(width: 24, height: 24)
            //             .padding(.horizontal, 2)
            //             .padding(.vertical, 4)
            //         // FIXME: - if push
            //         Circle()
            //             .foregroundColor(.red)
            //             .frame(width: 12, height: 12)
            //             .overlay(Circle().stroke(.white, lineWidth: 4))
            //     }
            // }

            if let user = sharedData.user {
                NavigationLink {
                    ProfileView(uid: user.uid)
                } label: {
                    Assets.Default.profile.image
                        .resizable()
                        .frame(width: 42, height: 42)
                        .cornerRadius(26)
                }
            } else {
                NavigationLink {
                    AuthView()
                } label: {
                    Text(LocalizedString.signIn)
                        .font(.SFOMSmallFont)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(16)
                        .frame(height: 24)

                }
            }
        }
            .padding()
    }

    private var postItemsView: some View {
        VStack {
            ForEach(homeViewModel.posts, id: \.id) { post in
                SFOMPostItemView(post: post) {
                    PostView(post: post)
                }
            }
        }
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let noAuth: SharedData = SharedData()

        var auth: SharedData {
            let sharedData = SharedData()
            sharedData.user = User(uid: "uid", nickname: "", profileImage: "")
            return sharedData
        }

        return Group {
            HomeView()
                .environment(\.locale, .init(identifier: "ko"))
            HomeView()
                .environment(\.locale, .init(identifier: "en"))
        }
            .environmentObject(auth)
    }
}
