//
//  HomeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine

final class HomeViewModel: ViewModel {
    private let homeUseCase: HomeUseCase = DefaultHomeUseCase(postRepository: DefaultPostRepository(networkService: FirebaseService.shared),commentEventRepository: DefaultCommentEventRepository(networkService: FirebaseService.shared))
    
    @Published var posts: [Post] = []
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        homeUseCase.fetchPost()
            .replaceError(with: [])
            .assign(to: \.posts, on: self)
            .store(in: &cancellable)
        
        homeUseCase.fetchRecentComment()
            .sink { _ in
                print("x")
            } receiveValue: { c in
                print(c)
            }.store(in: &cancellable)

    }
}

struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            homeNavigationBar
            
            ScrollView(.horizontal, showsIndicators: false) {
                postItemsView
            }
            .onAppear{
                UIScrollView.appearance().isPagingEnabled = true
            }
            Spacer()
        }
    }
    
    private var homeNavigationBar: some View {
        HStack(alignment: .center) {
            Text(Localized.homeTitle)
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
            
            NavigationLink {
                // ProfileView(uid: user.uid)
            } label: {
                Assets.Default.profile.image
                    .resizable()
                    .frame(width: 42, height: 42)
                    .cornerRadius(26)
            }
            NavigationLink {
                AuthView()
            } label: {
                Text(Localized.signIn)
                    .font(.SFOMSmallFont)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(16)
                    .frame(height: 24)
                
            }
            
        }
        .padding()
    }
    
    private var postItemsView: some View {
        HStack {
            ForEach(viewModel.posts, id: \.id) { post in
                SFOMPostItemView(post: post) {
                    PostView(post: post)
                }
            }
        }
        .frame(height: 200)
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            HomeView()
                .environment(\.locale, .init(identifier: "ko"))
            HomeView()
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
