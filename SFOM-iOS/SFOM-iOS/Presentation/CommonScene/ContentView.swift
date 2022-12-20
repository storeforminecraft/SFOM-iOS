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
    
    @Published var authorUser: User? = nil
    @Published var authorUserResources: [Resource] = []
    @Published var resourceComments: [Comment] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    func bind(resource: Resource){
        contentUseCase
            .fetchUser(uid: resource.authorUid)
            .map{ user -> User? in user }
            .replaceError(with: nil)
            .assign(to: \.authorUser, on: self)
            .store(in: &cancellable)
        
        contentUseCase
            .fetchUserResources(uid: resource.authorUid)
            .replaceError(with: [])
            .assign(to: \.authorUserResources, on: self)
            .store(in: &cancellable)
        
        contentUseCase
            .fetchComment(resourceId: resource.id)
            .replaceError(with: [])
            .assign(to: \.resourceComments, on: self)
            .store(in: &cancellable)
        
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
            }
        }
        .overlay {
            // File Download & apply
        }
    }
    
    var imagesTabView: some View {
        TabView{
            ForEach(resource.imageUrls, id: \.hashValue) { image in
                SFOMImage(urlString: image)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    var resourceContent: some View {
        VStack(alignment: .leading) {
            Text(resource.localizedName)
                .font(.SFOMMediumFont.bold())
            Text(resource.info)
                .foregroundColor(Color(.darkGray))
            userInfo
                .padding(.vertical)
            Text(resource.localizedDescs)
                .font(.SFOMSmallFont)
                .foregroundColor(Color(.darkGray))
        }
    }
    
    var userInfo: some View {
        VStack {
            if let user = viewModel.authorUser {
                NavigationLink {
                    ProfileView(uid: user.uid)
                } label: {
                    HStack {
                        // FIXME: - SFOMImage DefaultImage
                        Group{
                            if let thumbnail = user.thumbnail {
                                SFOMImage(urlString: thumbnail)
                            } else {
                                Assets.Default.profile.image
                            }
                        }
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        
                        VStack(alignment: .leading, spacing: 0){
                            Text(user.nickname)
                                .font(.SFOMSmallFont.bold())
                                .foregroundColor(.black)
                            Text(user.uid.prefix(6))
                                .font(.SFOMSmallFont)
                                .foregroundColor(Color(.darkGray))
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {    
    static var previews: some View {
        ContentView(resource: TestResource.resource)
    }
}
