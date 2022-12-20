//
//  HomeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine

final class HomeViewModel: ViewModel {
    private let homeUseCase: HomeUseCase = AppContainer.shared.homeUseCase
    
    @Published var currentUser: User? = nil
    @Published var posts: [Post] = []
    @Published var recentComments: [RecentComment] = []
    @Published var pushNotification: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind(){
        homeUseCase.fetchCurrentUser()
            .map{ user -> User? in user }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellable)
        
        homeUseCase.fetchPost()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.posts, on: self)
            .store(in: &cancellable)
        
        homeUseCase.fetchRecentComment()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.recentComments, on: self)
            .store(in: &cancellable)
    }
}

struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            homeNavigationBar
            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false) {
                    postItemsView
                }
                recentsCommentsView
                    .padding()
                Spacer()
            }
            
        }
    }
    
    private var categoryTabButtons: some View {
        VStack{
            
        }
    }
    
    private var homeNavigationBar: some View {
        HStack(alignment: .center) {
            Text(Localized.homeTitle)
                .font(.SFOMTitleFont)
            Spacer()
            
            NavigationLink {
                PushView()
            } label: {
                ZStack (alignment: .topTrailing) {
                    Assets.MoreMenu.push.image
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 2)
                        .padding(.vertical, 4)
                    if viewModel.pushNotification {
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(.white, lineWidth: 4))
                    }
                }
            }
            
            if let uid = viewModel.currentUser?.uid {
                NavigationLink {
                    ProfileView(uid: uid)
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
    
    private var recentsCommentsView: some View {
        VStack {
            ForEach(viewModel.recentComments,id: \.comment.id) { recentComment in
                SFOMRecentCommentItemView(recentComment: recentComment) {
                    ContentView(resource: recentComment.resource)
                }
            }
        }
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
