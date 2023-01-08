//
//  HomeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine

import Kingfisher

final class HomeViewModel: ViewModel {
    private let homeUseCase: HomeUseCase = AppContainer.shared.homeUseCase
    
    @Published var currentUser: User? = nil
    @Published var posts: [Post] = []
    @Published var recentComments: [RecentComment] = []
    @Published var pushNotification: Bool = false
    @Published var isCommentLoading: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    deinit{
        cancellable.removeAll()
    }
    
    func bind(){
        homeUseCase.fetchCurrentUserWithUidChanges()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.currentUser = user
            })
            .store(in: &cancellable)
        
        homeUseCase.fetchPost()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.posts, on: self)
            .store(in: &cancellable)
        
        isCommentLoading = true
        homeUseCase.fetchRecentComment()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { recentComments in
                withAnimation {
                    self.isCommentLoading = false
                }
                self.recentComments = recentComments
            })
            .store(in: &cancellable)
    }
}

struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
    private let imageCache: ImageCache = ImageCache.default
    
    let categorySequence: [SFOMCategory] = [.map,
                                            .skin,
                                            .script,
                                            .seed,
                                            .texturepack,
                                            .mod,
                                            .addon,
                                            .downloads]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            homeNavigationBar
                .padding(.bottom, 14)
                .padding(.top, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                categoryTabButtons
                    .padding(.top, 14)
                ScrollView(.horizontal, showsIndicators: false) {
                    postItemsView
                }
                recentsCommentsView
                    .padding()
                Spacer()
            }
        }
        .onAppear {
            print("🍎 cacheClear")
            self.imageCache.clearMemoryCache()
        }
    }
    
    private var categoryTabButtons: some View {
        VStack (spacing: 18) {
            ForEach((0..<(self.categorySequence.count / 4)),
                    id: \.hashValue) { row in
                HStack {
                    Spacer()
                    ForEach(0..<4) { column in
                        SFOMCategoryTapView(category: categorySequence[4 * row + column]) {
                            if categorySequence[4 * row + column] != .downloads {
                                CategoryView(category: categorySequence[4 * row + column])
                            } else {
                                DownloadListView()
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var homeNavigationBar: some View {
        HStack(alignment: .center) {
            Text(StringCollection.Default.homeTitle.localized)
                .font(.SFOMTitleFont)
            Spacer()
            
            // TODO: - NextUpdate: Push
            // NavigationLink {
            //     PushView()
            // } label: {
            //     ZStack (alignment: .topTrailing) {
            //         Assets.MoreMenu.push.image
            //             .resizable()
            //             .frame(width: 20, height: 20)
            //             .padding(.horizontal, 2)
            //             .padding(.vertical, 4)
            //         if viewModel.pushNotification {
            //             Circle()
            //                 .foregroundColor(.red)
            //                 .frame(width: 12, height: 12)
            //                 .overlay(Circle().stroke(.white, lineWidth: 4))
            //         }
            //     }
            // }
            
            SFOMSignInLink(user: $viewModel.currentUser) {
                ProfileView(uid: viewModel.currentUser?.uid ?? "")
            } noAuth: {
                AuthView()
            }
        }
        .padding(.horizontal, 32)
    }
    
    private var postItemsView: some View {
        HStack {
            ForEach(viewModel.posts, id: \.id) { post in
                SFOMPostItemView(post: post) {
                    PostView(post: post)
                }
            }
        }
        .padding()
    }
    
    private var recentsCommentsView: some View {
        VStack {
            if viewModel.isCommentLoading {
                ActivityIndicator(isAnimating: $viewModel.isCommentLoading, style: .medium)
            } else {
            ForEach(viewModel.recentComments,id: \.comment.id) { recentComment in
                SFOMRecentCommentItemView(recentComment: recentComment) {
                    ContentView(resource: recentComment.resource)
                }
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
