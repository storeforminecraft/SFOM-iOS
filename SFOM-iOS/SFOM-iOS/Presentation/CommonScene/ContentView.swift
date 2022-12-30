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
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func bind(resource: Resource){
        contentUseCase.fetchCurrentUserWithUidChanges()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.currentUser = user
            })
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUser(uid: resource.authorUid)
            .map{ user -> User? in user }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { user in
                self.authorUser = user
            })
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUserResources(uid: resource.authorUid)
            .receive(on: DispatchQueue.main)
            .map{ resources in
                resources
                    .filter { resource.id != $0.id }
                    .sorted { $0.createdTimestamp > $1.createdTimestamp }
            }
            .replaceError(with: [])
            .sink(receiveValue: { resources in
                self.authorUserResources = resources
            })
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUserComment(resourceId: resource.id)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { resourceComments in
                self.resourceComments = resourceComments
            })
            .store(in: &cancellable)
    }
    
    func addComments(comment: String){
        
    }
}

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    let resource: Resource
    @State private var showDownload: Bool = false
    
    @State var comment: String = ""
    @State var isReports: Bool = false
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                imagesTabView
                    .aspectRatio(1.7, contentMode: .fit)
                    .padding(.bottom, 10)
                resourceContent
                    .padding(.horizontal, 20)
                Divider()
                    .padding(.vertical,10)
                comments
                    .padding(.horizontal, 20)
                Divider()
                    .padding(.vertical,10)
                userResources
            }
            .padding(.bottom, 100)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .overlay(alignment: .bottom) {
            SFOMDownloadButton(Localized.ContentView.download) {
                showDownload = true
            }
            .padding()
        }
        .onAppear {
            viewModel.bind(resource: resource)
        }
        .sheet(isPresented: $showDownload) {
            DownloadView()
        }
        
        // .confirmationDialog(Localized.ETC.signOutMessage,
        //                     isPresented: $isReports,
        //                     titleVisibility: .visible) {
        //     Button(Localized.MoreMenu.signOut, role: .destructive) {
        //
        //     }
        // }
    }
    
    @ViewBuilder
    private var imagesTabView: some View {
        if resource.category != .skin {
            TabView{
                ForEach(resource.imageUrls, id: \.hashValue) { image in
                    SFOMImage(placeholder: Assets.Default.profileBackground.image,
                              urlString: image)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        } else {
            SFOMSkinImage(placeholder: Assets.Default.profileBackground.image,
                          urlString: resource.thumbnail)
        }
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
                    HStack (spacing: 10) {
                        // FIXME: - SFOMImage DefaultImage
                        SFOMImage(placeholder: Assets.Default.profile.image,
                                  urlString: user.thumbnail)
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        
                        VStack(alignment: .leading, spacing: 0){
                            Text(user.nickname.strip)
                                .font(.SFOMExtraSmallFont.bold())
                                .foregroundColor(.black)
                                .lineLimit(1)
                            Text(user.uid.prefix(6))
                                .font(.SFOMExtraSmallFont)
                                .foregroundColor(Color(.darkGray))
                                .lineLimit(1)
                            HStack { Spacer() }
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
                    Text(comment)
                    VStack(spacing: 0){
                        TextField("평가를 작성해주세요", text: $comment)
                            .autocapitalization(.none)
                            .padding(8)
                            .padding(.horizontal, 2)
                            .font(.SFOMSmallFont)
                            .onSubmit {
                                print("⭐️")
                                viewModel.addComments(comment: comment)
                                comment = ""
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
                            SFOMImage(placeholder: Assets.Default.profile.image,
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
                                        .font(.SFOMExtraSmallFont.bold())
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Button {
                                    // FIXME: - 신고
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.SFOMExtraSmallFont)
                                        .foregroundColor(Color(.lightGray))
                                }
                            }
                            Text(userComment.comment.content)
                                .font(.SFOMExtraSmallFont)
                                .foregroundColor(Color(.darkGray))
                            HStack{ Spacer() }
                        }
                        .padding()
                        .background(Color(.lightGray).opacity(0.08))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var userResources: some View {
        VStack(spacing: 10){
            VStack(alignment:.leading, spacing: 5){
                if let authorUser = viewModel.authorUser {
                    HStack(spacing: 0) {
                        Text(authorUser.nickname.strip)
                            .font(.SFOMSmallFont.bold())
                        Text(Localized.ETC.userSuffix)
                            .font(.SFOMSmallFont)
                    }
                    .foregroundColor(.black)
                    if let introduction = authorUser.introduction{
                        Text(introduction)
                            .font(.SFOMExtraSmallFont)
                            .foregroundColor(Color(.lightGray))
                    }
                }
                HStack { Spacer() }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10){
                    ForEach(viewModel.authorUserResources, id: \.id) { resource in
                        NavigationLink {
                            ContentView(resource: resource)
                        } label: {
                            VStack(alignment: .leading) {
                                SFOMImage(placeholder: Assets.Default.profileBackground.image,
                                          urlString: resource.thumbnail)
                                .aspectRatio(1.7, contentMode: .fit)
                                .padding(.bottom,4)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(resource.localizedName)
                                        .font(.SFOMExtraSmallFont)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .frame(height: 30, alignment: .top)
                                    HStack (spacing: 0) {
                                        Image(systemName: "hand.thumbsup.fill")
                                            .font(.SFOMExtraSmallFont)
                                            .foregroundColor(.accentColor)
                                        Group {
                                            Text("\(resource.likeCount)")
                                                .padding(.trailing,4)
                                            Text("\(resource.downloadCount)\(Localized.ETC.count)")
                                        }
                                        .font(.SFOMExtraSmallFont)
                                        .foregroundColor(Color(.lightGray))
                                        .lineLimit(1)
                                    }
                                }
                                .padding(.horizontal, 6)
                                .padding(.bottom,8)
                            }
                            .frame(width: 150)
                            .background(Color(.white))
                            .cornerRadius(12)
                            .shadow(color: Color(.lightGray),
                                    radius: 2, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            HStack { Spacer() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {    
    static var previews: some View {
        ContentView(resource: TestResource.resource)
    }
}
