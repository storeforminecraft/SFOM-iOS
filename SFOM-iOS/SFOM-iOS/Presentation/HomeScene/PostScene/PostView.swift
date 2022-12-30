//
//  PostView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/02.
//

import SwiftUI
import Combine

final class PostViewModel: ViewModel {
    private let postUseCase: PostUseCase = AppContainer.shared.postUseCase
    
    @Published var authorUser: User? = nil
    @Published var resource: [String: Resource] = [:]
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func bind(post: Post){
        postUseCase
            .fetchUser(uid: post.authorUid)
            .map{ user -> User? in user }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { user in
                self.authorUser = user
            })
            .store(in: &cancellable)
    }
}

struct PostView: View {
    @ObservedObject private var viewModel: PostViewModel = PostViewModel()
    
    let post: Post
    
    init(post: Post) {
        self.post = post
        viewModel.bind(post: post)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                SFOMImage(placeholder: Assets.Default.profileBackground.image,
                          urlString: post.coverImage)
                .aspectRatio(1, contentMode: .fill)
                VStack(alignment: .leading) {
                    postInfo
                    if let user = viewModel.authorUser {
                        UserInfoLink(user: user) {
                            ProfileView(uid: user.uid)
                        }
                    }
                    HStack { Spacer() }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
    }
    
    private var postInfo: some View {
        VStack(alignment: .leading){
            HStack(spacing: 4){
                Assets.Symbol.white.image
                    .resizable()
                    .frame(width: 12,height: 12)
                    .colorMultiply(.black)
                Text("#\(post.boardId)")
                    .font(.SFOMExtraSmallFont.bold())
            }
            
            Text(post.title)
                .font(.SFOMMediumFont.bold())
        }
    }
    
    private var userInfo: some View {
        VStack {
            if let user = viewModel.authorUser {

            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: TestResource.posts)
    }
}
