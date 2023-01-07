//
//  ContentView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/02.
//

import SwiftUI
import Combine

// FIXME: - update comment
final class ContentViewModel: ViewModel {
    private let contentUseCase: ContentUseCase = AppContainer.shared.contentUseCase
    
    @Published var currentUser: User? = nil
    @Published var authorUser: User? = nil
    @Published var authorUserResources: [Resource] = []
    @Published var resourceComments: [UserComment] = []
    
    @Published var comment: String = ""
    
    private var selectedContent: String = ""
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    deinit{
        cancellable.removeAll()
    }
    
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
            .replaceError(with: [])
            .sink(receiveValue: { resources in
                self.authorUserResources = resources
                    .filter { resource.id != $0.id }
                    .sorted { $0.modifiedTimestamp > $1.modifiedTimestamp }
            })
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUserComment(resourceId: resource.id)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { resourceComments in
                self.resourceComments = resourceComments
                    .sorted { $0.comment.modifiedTimestamp > $1.comment.modifiedTimestamp }
            })
            .store(in: &cancellable)
    }
    
    func addComments(){
        
    }
}

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    let resource: Resource
    
    @State private var showDownload: Bool = false
    @State var showReports: Bool = false

    
    init(resource: Resource) {
        self.resource = resource
    }
    
    var body: some View {
        ScrollView (showsIndicators: false){
            VStack(alignment: .leading) {
                imagesTabView
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 10)
                resourceContent
                    .padding(.horizontal, 20)
                Divider()
                    .padding(.vertical,10)
                commentsList
                    .padding(.horizontal, 20)
                Divider()
                    .padding(.vertical,10)
                userResources
            }
            .padding(.bottom, 100)
        }
        // .gesture(magnificationGesture)
        .gesture(MagnificationGesture())
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .overlay(alignment: .bottom) {
            SFOMDownloadButton(StringCollection.ContentView.download.localized) {
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
        .confirmationDialog(StringCollection.Report.report.localized,
                            isPresented: $showReports,
                            titleVisibility: .visible) {
            Button(StringCollection.Report.report.localized, role: .destructive) {
                
            }
        }
    }
    
    @ViewBuilder
    private var imagesTabView: some View {
        if !resource.isSkin {
            TabView{
                ForEach(resource.imageUrls, id: \.hashValue) { image in
                    SFOMImage(placeholder: Assets.Default.profileBackground.image,
                              urlString: image)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        } else {
            SFOMImage(placeholder: Assets.Default.profileBackground.image,
                          urlString: resource.thumbnail,
                      isSkin: true)
            .padding(.top, 30)
            .background(Assets.Default.gradientBackground.image)
        }
    }
    
    private var resourceContent: some View {
        VStack(alignment: .leading) {
            Text(resource.localizedName)
                .font(.SFOMSmallFont.bold())
            Text(resource.info)
                .foregroundColor(Color(.darkGray))
                .font(.SFOMExtraSmallFont)
            if let user = viewModel.authorUser {
                UserInfoLink(user: user) {
                    ProfileView(uid: user.uid)
                }
                .padding(.vertical)
            }
                
            Text(resource.localizedDescs)
                .font(.SFOMExtraSmallFont)
                .foregroundColor(Color(.darkGray))
        }
    }
    
    private var commentsList: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(StringCollection.ContentView.comments.localized.capitalized)
                    .font(.SFOMSmallFont.bold())
                Spacer()
                NavigationLink{
                    CommentsView(resource: resource,
                                 userComments: viewModel.resourceComments)
                } label: {
                    HStack(spacing: 0){
                        Text(StringCollection.ContentView.more.localized)
                        Image(systemName: "chevron.forward")
                    }
                    .font(.SFOMSmallFont)
                }
            }
            .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                if viewModel.currentUser != nil {
                    VStack(spacing: 0){
                        SFOMSubmitField(StringCollection.ContentView.pleaseLeaveAComments.localized, text: $viewModel.comment) {
                            viewModel.addComments()
                        }
                           
                        HStack { Spacer() }
                    }
                    .padding()
                } else {
                    VStack(alignment: .center){
                        NavigationLink{
                            AuthView()
                        } label: {
                            Text(StringCollection.ContentView.leaveACommentAfterSignIn.localized)
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
                        Text(StringCollection.ETC.userSuffix.localized)
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
                        SFOMResourceItemView(resource: resource) {
                            ContentView(resource: resource)
                        }
                        .frame(width: 150)
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
