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

    @Published var posts: [Post] = []
    @Published var recentComments: [RecentComment] = []
    @Published var pushNotification: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind(){        
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
    @AppStorage("User") var currentUser: User? = UserDefaults.standard.object(forKey: "User") as? User
    
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
                        SFOMCategoryTapTempView(category: categorySequence[4 * row + column]) {
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
            
            if let uid = currentUser?.uid {
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

public struct SFOMCategoryTapTempView<Destination>: View where Destination: View {
    let category: SFOMCategory
    let frame: CGFloat
    let imagePadding: CGFloat
    @ViewBuilder var destination:() -> Destination
    
    init(category: SFOMCategory,
         frame: CGFloat = 18,
         imagePadding: CGFloat? = nil,
         @ViewBuilder destination: @escaping () -> Destination) {
        self.category = category
        self.frame = frame
        if let imagePadding = imagePadding {
            self.imagePadding = imagePadding
        } else {
            self.imagePadding = frame / 10 * 8
        }
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            VStack (alignment: .center) {
                category.assets.image
                    .resizable()
                    .frame(width: self.frame, height: self.frame)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(category.assets.tintColor)
                    .padding(imagePadding)
                    .background(category.assets.backgroundColor)
                    .cornerRadius(self.frame + imagePadding)
                
                Text(category.localized)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
