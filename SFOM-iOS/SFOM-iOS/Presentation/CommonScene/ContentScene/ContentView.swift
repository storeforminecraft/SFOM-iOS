//
//  ContentView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/02.
//

import SwiftUI
import Combine
import AlertToast

// FIXME: - update comment
final class ContentViewModel: ViewModel {
    private let contentUseCase: ContentUseCase = AppContainer.shared.contentUseCase
    private var resource: Resource? = nil
    
    @Published var thumb: ResourceThumb = ResourceThumb.empty
    
    @Published var currentUser: User? = nil
    @Published var authorUser: User? = nil
    @Published var authorUserResources: [Resource] = []
    @Published var resourceComments: [UserComment] = []
    
    @Published var comment: String = ""
    
    var selectedTargetPath: String? = nil
    
    private var selectedContent: String = ""
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    deinit{
        cancellable.removeAll()
    }
    
    func bind(resource: Resource){
        self.resource = resource
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
                withAnimation {
                    self.authorUser = user
                }
            })
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUserResources(uid: resource.authorUid)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink(receiveValue: { resources in
                withAnimation {
                    self.authorUserResources = resources
                        .filter { resource.id != $0.id }
                        .sorted { $0.modifiedTimestamp > $1.modifiedTimestamp }
                }
            })
            .store(in: &cancellable)
        
        contentUseCase.fetchThumb(resourceId: resource.id)
            .replaceError(with: ResourceThumb.empty)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] thumb in
                withAnimation {
                    self?.thumb = thumb
                }
            }
            .store(in: &cancellable)
        
        fetchComment()
    }
    
    func fetchComment(){
        guard let resource = resource else { return }
        contentUseCase
            .fetchUserComment(resourceId: resource.id, limit: 5)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { resourceComments in
                withAnimation {
                    self.resourceComments = resourceComments
                        .sorted { $0.comment.modifiedTimestamp > $1.comment.modifiedTimestamp }
                }
            })
            .store(in: &cancellable)
    }
    
    func pushThumb(){
        guard let resource = resource else { return }
        if !thumb.isThumb {
            self.thumb = ResourceThumb(thumbCount: self.thumb.thumbCount + 1, isThumb: !self.thumb.isThumb)
            contentUseCase.pushThumb(category: resource.category.rawValue, resourceId: resource.id)
                .replaceError(with: ResourceThumb.empty)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] thumb in
                    withAnimation{
                        self?.thumb = thumb
                    }
                }
                .store(in: &cancellable)
        } else {
            self.thumb = ResourceThumb(thumbCount: self.thumb.thumbCount - 1, isThumb: !self.thumb.isThumb)
            contentUseCase.deleteThumb(resourceId: resource.id)
                .replaceError(with: ResourceThumb.empty)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] thumb in
                    withAnimation{
                        self?.thumb = thumb
                    }
                }
                .store(in: &cancellable)
        }
    }
    
    func leaveComment(){
        
    }
}

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    private let resource: Resource
    private let resourcePath: String
    
    @State private var showDownload: Bool = false
    @State var showCommentMenu: Bool = false
    @State var showReports: Bool = false
    @State var showNeedAuth: Bool = false
    
    
    init(resource: Resource) {
        self.resource = resource
        self.resourcePath = "resources/\(resource.id)"
    }
    
    var body: some View {
        ScrollView (showsIndicators: false){
            VStack(alignment: .leading) {
                imagesTabView
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 10)
                resourceContent
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                Divider()
                    .padding(.vertical, 14)
                commentsList
                    .padding(.horizontal, 20)
                Divider()
                    .padding(.vertical, 14)
                userResources
            }
            .padding(.bottom, 100)
        }
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
        .confirmationDialog(StringCollection.Report.report.localized,
                            isPresented: $showCommentMenu,
                            titleVisibility: .hidden) {
            Button(StringCollection.Report.report.localized, role: .destructive) {
                if viewModel.currentUser != nil {
                    showReports.toggle()
                } else {
                    showNeedAuth.toggle()
                }
            }
        }
        .sheet(isPresented: $showDownload) {
            DownloadView(resource: resource)
        }
        .sheet(isPresented: $showReports) {
            ReportView(viewModel.selectedTargetPath ?? "", isComment: true)
        }
        .toast(isPresenting: $showNeedAuth,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(type: .error(.red),
                       title: StringCollection.NeedAuth.needAuthTitle.localized,
                       subTitle: StringCollection.NeedAuth.needAuthDescription.localized)
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
        VStack(alignment: .leading, spacing: 0) {
            Text(resource.localizedName)
                .font(.SFOMFont16.bold())
            
            Text(resource.info)
                .foregroundColor(Color(.darkGray))
                .font(.SFOMFont12)
                .padding(.top, 4)
            
            resourceButtons
            
            VStack {
                if let user = viewModel.authorUser {
                    UserInfoLink(user: user) {
                        ProfileView(uid: user.uid)
                    }
                }
            }
            .frame(height: 30)
            .padding(.vertical)
            
            Text(resource.localizedDescs)
                .font(.SFOMFont12)
                .foregroundColor(Color(.darkGray))
        }
    }
    
    private var commentsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(StringCollection.ContentView.comments.localized)
                    .font(.SFOMFont16.bold())
                Spacer()
                NavigationLink{
                    CommentsView(resource: resource,
                                 userComments: viewModel.resourceComments)
                } label: {
                    HStack(spacing: 0){
                        Text(StringCollection.ContentView.more.localized)
                        Image(systemName: "chevron.forward")
                    }
                    .font(.SFOMFont16)
                }
            }
            
            VStack(alignment: .leading) {
                if viewModel.currentUser != nil {
                    VStack(spacing: 0){
                        SFOMSubmitField(StringCollection.ContentView.pleaseLeaveAComments.localized, text: $viewModel.comment) {
                            viewModel.leaveComment()
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
                                .font(.SFOMFont16.bold())
                        }
                        HStack{ Spacer() }
                    }
                    .padding()
                }
                
                ForEach(viewModel.resourceComments[0..<min(viewModel.resourceComments.count, 3)],
                        id: \.comment.id) { userComment in
                    userCommentView(path: resourcePath, userComment: userComment) { targetPath in
                        viewModel.selectedTargetPath = targetPath
                        showCommentMenu.toggle()
                    } destination: {
                        ProfileView(uid: userComment.user.uid)
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
                            .font(.SFOMFont16.bold())
                        Text(StringCollection.ETC.userSuffix.localized)
                            .font(.SFOMFont16)
                    }
                    .foregroundColor(.black)
                    if let introduction = authorUser.introduction{
                        Text(introduction)
                            .font(.SFOMFont12)
                            .foregroundColor(Color(.lightGray))
                    }
                }
                HStack { Spacer() }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
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
    
    private var resourceButtons: some View {
        // HStack(alignment: .center, spacing: 10){
        //     Button {
        //         viewModel.pushThumb()
        //     } label: {
        //         HStack(alignment: .center){
        //             Assets.Content.thumb.image
        //                 .blendMode(.colorBurn)
        //                 .frame(width: 14, height: 14)
        //
        //                 // .colorMultiply(.accentColor)
        //         }
        //     }
        // }
        VStack {}
    }
}

struct ContentView_Previews: PreviewProvider {    
    static var previews: some View {
        ContentView(resource: TestResource.resource)
    }
}
