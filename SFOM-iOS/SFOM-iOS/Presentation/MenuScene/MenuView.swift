//
//  MenuView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine

final class MenuViewModel: ViewModel {
    private let menuUseCase: MenuUseCase = AppContainer.shared.menuUseCase
    
    @Published var currentUser: User? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        menuUseCase.fetchCurrentUser()
            .map{ user -> User? in user }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellable)
    }
}

struct MenuView: View {
    @ObservedObject var viewModel: MenuViewModel = MenuViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            profile
            List {
                Section{
                    contentStudioItem
                }
                settingListSection
            }
            .padding(.vertical, 10)
            .listStyle(PlainListStyle())
        }
        .padding()
    }
    
    private var profile: some View {
        VStack (alignment: .leading){
            if let user = viewModel.currentUser {
                NavigationLink {
                    ProfileView(uid: user.uid)
                } label: {
                    HStack{
                        Assets.Default.profile.image
                            .resizable()
                            .frame(width: 42, height: 42)
                            .cornerRadius(26)
                        Text(user.nickname)
                            .font(.SFOMMediumFont.bold())
                    }
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
    }
    
    private var settingListSection: some View {
        Section {
            SFOMListItemView(moreMenu: .download) {
                DownloadView()
            }
            SFOMListItemView(moreMenu: .notice) {
                NoticeView()
            }
            SFOMListItemView(moreMenu: .settings) {
                SettingsView()
            }
            if let _ = viewModel.currentUser {
                SFOMListItemView(moreMenu: .myComments) {
                    MyCommentsView()
                }
                SFOMListItemView(moreMenu: .signOut) {
                    AuthView()
                }
            }
        }
        .listRowSeparator(.hidden)
    }
    
    var contentStudioItem: some View {
        VStack { }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
