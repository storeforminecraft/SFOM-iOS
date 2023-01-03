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
    
    let categorySequence: [SFOMCategory] = [.map,
                                            .skin,
                                            .script,
                                            .seed,
                                            .texturepack,
                                            .mod,
                                            .addon,
                                            .downloads]
    
    var body: some View {
        VStack (alignment: .leading) {
            homeNavigationBar
            ScrollView(.vertical, showsIndicators: false) {
                categoryTabButtons
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
        VStack (spacing: 10) {
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
            
            if let uid = viewModel.currentUser?.uid {
                NavigationLink {
                    ProfileView(uid: uid)
                } label: {
                    Assets.Default.profile.image
                        .resizable()
                        .frame(width: 36, height: 36)
                        .cornerRadius(18)
                }
            } else {
                NavigationLink {
                    AuthView()
                } label: {
                    Text(StringCollection.Default.signIn.localized)
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
