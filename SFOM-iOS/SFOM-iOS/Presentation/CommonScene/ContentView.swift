//
//  ContentView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/02.
//

import SwiftUI
import Combine

final class ContentViewModel: ViewModel {
    private let contentUseCase: ContentUseCase = AppContainer.shared.contentUseCase

    @Published var currentUser: User? = nil
    @Published var authorUser: User? = nil
    @Published var authorUserResources: [Resource] = []
    @Published var resourceComments: [UserComment] = []
    
    @Published var comment: String = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    func bind(resource: Resource){
        contentUseCase.fetchCurrentUserWithUidChanges()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUser(uid: resource.authorUid)
            .map{ user -> User? in user }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.authorUser, on: self)
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUserResources(uid: resource.authorUid)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.authorUserResources, on: self)
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUserComment(resourceId: resource.id)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.resourceComments, on: self)
            .store(in: &cancellable)
    }
    
    func addComments(){
        
    }
}

struct ContentView: View {
    @ObservedObject private var viewModel: ContentViewModel = ContentViewModel()
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
        viewModel.bind(resource: resource)
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                imagesTabView
                    .aspectRatio(1.7, contentMode: .fit)
                resourceContent
                    .padding(.horizontal, 20)
                Divider()
                    .padding(.vertical)
                comments
                    .padding(.horizontal, 20)
                Divider()
                    .padding(.vertical)
                userResources
                    .padding()
            }
        }
        .ignoresSafeArea()
        .overlay {
            // File Download & apply
        }
    }
    
    private var imagesTabView: some View {
        TabView{
            ForEach(resource.imageUrls, id: \.hashValue) { image in
                SFOMImage(urlString: image)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    private var resourceContent: some View {
        VStack(alignment: .leading) {
            Text(resource.localizedName)
                .font(.SFOMSmallFont.bold())
            Text(resource.info)
                .foregroundColor(Color(.darkGray))
                .font(.SFOMExtraSmallFont)
            userInfo
                .padding(.vertical)
            Text(resource.localizedDescs)
                .font(.SFOMExtraSmallFont)
                .foregroundColor(Color(.darkGray))
        }
    }
    
    private var userInfo: some View {
        VStack {
            if let user = viewModel.authorUser {
                NavigationLink {
                    ProfileView(uid: user.uid)
                } label: {
                    HStack {
                        // FIXME: - SFOMImage DefaultImage
                        SFOMImage(defaultImage: Assets.Default.profile.image,
                                  urlString: user.thumbnail)
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        
                        VStack(alignment: .leading, spacing: 0){
                            Text(user.nickname)
                                .font(.SFOMExtraSmallFont.bold())
                                .foregroundColor(.black)
                            Text(user.uid.prefix(6))
                                .font(.SFOMExtraSmallFont)
                                .foregroundColor(Color(.darkGray))
                        }
                    }
                }
            }
        }
    }
    
    private var comments: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Localized.ContentView.comments.capitalized)
                    .font(.SFOMSmallFont.bold())
                Spacer()
                NavigationLink{
                    CommentsView(resource: resource,
                                 userComments: viewModel.resourceComments)
                } label: {
                    HStack(spacing: 0){
                        Text(Localized.ContentView.more)
                        Image(systemName: "chevron.forward")
                    }
                    .font(.SFOMSmallFont)
                }
            }
            .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                if viewModel.currentUser != nil {
                    // FIXME: - 댓글 쓰기
                    VStack(spacing: 0){
                    TextField("평가를 작성해주세요", text: $viewModel.comment)
                        .autocapitalization(.none)
                        .padding(8)
                        .padding(.horizontal, 2)
                        .font(.SFOMSmallFont)
                        .onSubmit {
                            viewModel.addComments()
                        }
                        HStack { Spacer() }
                    }
                        .background(Color.searchBarColor)
                        .cornerRadius(24)
                        .overlay(RoundedRectangle(cornerRadius: 24)
                            .stroke(.black, lineWidth: 2))
                        .padding()
                } else {
                    VStack(alignment: .center){
                        NavigationLink{
                            AuthView()
                        } label: {
                            Text(Localized.ContentView.signInAndWriteAComment)
                                .font(.SFOMSmallFont.bold())
                        }
                        HStack{ Spacer() }
                    }.padding()
                    
                }
                
                ForEach(viewModel.resourceComments[0..<min(viewModel.resourceComments.count, 3)],
                        id: \.comment.id) { userComment in
                    HStack (alignment: .top){
                        NavigationLink {
                            ProfileView(uid: userComment.user.uid)
                        } label: {
                            SFOMImage(defaultImage: Assets.Default.profile.image,
                                      urlString: userComment.user.thumbnail)
                            .frame(width: 28, height: 28)
                            .cornerRadius(28)
                        }
                        
                        VStack (alignment: .leading, spacing: 4){
                            HStack(alignment: .center){
                                NavigationLink {
                                    ProfileView(uid: userComment.user.uid)
                                } label: {
                                    Text(userComment.user.summary)
                                        .font(.SFOMSmallFont.bold())
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Button {
                                    // FIXME: - 신고
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.SFOMSmallFont)
                                        .foregroundColor(Color(.lightGray))
                                }
                            }
                            Text(userComment.comment.content)
                                .font(.SFOMExtraSmallFont)
                                .foregroundColor(Color(.darkGray))
                            HStack{ Spacer() }
                        }
                        .padding()
                        .background(Color(.lightGray).opacity(0.05))
                        .cornerRadius(12)
                    }
                }
                
            }
        }
    }
    
    private var userResources: some View {
        VStack {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {    
    static var previews: some View {
        ContentView(resource: TestResource.resource)
    }
}
