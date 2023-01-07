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
    @Published var userResources: [String: UserResource] = [:]
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    deinit {
        cancellable.removeAll()
    }
    
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
        
        let resourceIds = (post.body?.body ?? [])
            .compactMap{ content in
            return content.type == "resource-linear-banner" ? content.data : nil
            }
        
        postUseCase.fetchResources(resourceIds: resourceIds)
            .map { userResources in
                Dictionary(uniqueKeysWithValues: userResources.map { userResource in
                    return (userResource.resource.id, userResource)
                })
            }
            .replaceError(with: [:])
            .receive(on: DispatchQueue.main)
            .assign(to: \.userResources, on: self)
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
            VStack {
                SFOMImage(placeholder: Assets.Default.profileBackground.image,
                          urlString: post.coverImage)
                .aspectRatio(1, contentMode: .fit)
                VStack(alignment: .leading, spacing: 10) {
                    postInfo
                    authorInfo
                        .padding(.vertical, 10)
                    postBody
                    
                    HStack { Spacer() }
                }
                .padding()
            }
            .padding(.bottom, 40)
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
                .font(.SFOMTitleFont)
        }
        .navigationBarBackButtonHidden()
    }
    
    private var authorInfo: some View {
        VStack(alignment: .leading){
            if let user = viewModel.authorUser {
                UserInfoLink(user: user) {
                    ProfileView(uid: user.uid)
                }
            }
        }
    }
    
    private var postBody: some View {
        VStack (alignment: .leading, spacing: 25){
            ForEach(post.body?.body ?? [],id: \.data) { content in
                switch content.type {
                case "h1":
                    Text(content.data)
                        .font(.SFOMMediumFont.bold())
                        .foregroundColor(.black)
                case "h2":
                    Text(content.data)
                        .font(.SFOMSmallFont.bold())
                        .foregroundColor(.black)
                case "text":
                    Text(content.data)
                        .font(.SFOMExtraSmallFont)
                        .foregroundColor(Color(.darkGray))
                case "link":
                    // CompactLPView(urlString: content.data)
                    // Text("link: \(content.data)")
                    //     .font(.body)
                    // FIXME: - Link 
                    VStack { }
                case "resource-linear-banner":
                    if let userResource = viewModel.userResources[content.data] {
                        ResourceLinearLink(userResource: userResource) {
                            ContentView(resource: userResource.resource)
                        }
                    } else {
                        Text("resource: \(content.data)")
                            .font(.SFOMExtraSmallFont)
                            .foregroundColor(Color(.lightGray))
                    }
                default:
                    Text("X \(content.type)")
                }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: TestResource.posts)
    }
}
