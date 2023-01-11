//
//  MenuView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine
import AlertToast

// FIXME: - Add ContentStudio

final class MenuViewModel: ViewModel {
    private let menuUseCase: MenuUseCase = AppContainer.shared.menuUseCase
    
    @Published var currentUser: User? = nil
    @Published var result: Bool? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind(){
        menuUseCase.fetchCurrentUserWithUidChanges()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.currentUser = user
            })
            .store(in: &cancellable)
    }
    
    func signOut() {
        result = nil
        menuUseCase.signOut()
            .map { result -> Bool? in result }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: \.result, on: self)
            .store(in: &cancellable)
    }
}

struct MenuView: View {
    @ObservedObject var viewModel: MenuViewModel = MenuViewModel()
    
    @State private var isSignOut: Bool = false
    @State private var isLoading: Bool = false
    @State private var signOutSuccess: Bool = false
    @State private var signOutFail: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            profile
                .padding(.top, 10)
            List {
                // FIXME: - ContentStudio
                // Section {
                //     contentStudioItem
                // }
                settingListSection
            }
            .listStyle(PlainListStyle())
            HStack { Spacer() }
        }
        .onReceive(viewModel.$result) { result in
            if let result = result {
                isLoading = false
                if result {
                    signOutSuccess = true
                } else {
                    signOutFail = true
                }
            }
        }
        .confirmationDialog(StringCollection.ETC.signOutMessage.localized,
                            isPresented: $isSignOut,
                            titleVisibility: .visible) {
            Button(StringCollection.MoreMenu.signOut.localized, role: .destructive) {
                isLoading = true
                viewModel.signOut()
            }
        }
        .toast(isPresenting: $signOutSuccess,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(type: .complete(.accentColor),
                       title: StringCollection.MoreMenu.signOut.localized,
                       subTitle: StringCollection.MoreMenu.signOutSuccess.localized)
        }
        .toast(isPresenting: $signOutFail,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(type: .error(.red),
                       title: StringCollection.MoreMenu.signOut.localized,
                       subTitle: StringCollection.MoreMenu.signOutFail.localized)
        }
    }
    
    private var profile: some View {
        VStack (alignment: .leading) {
            SFOMSignInLink(user: $viewModel.currentUser, circle: 20, showNickname: true) {
                ProfileView(uid: viewModel.currentUser?.uid ?? "")
            } noAuth: {
                AuthView()
            }
        }
        .padding(.horizontal, 36)
    }
    
    private var settingListSection: some View {
        Section {
            SFOMListItemLinkView(moreMenu: .download) {
                DownloadListView()
            }
            SFOMListItemLinkView(moreMenu: .notice) {
                NoticeView()
            }
            SFOMListItemLinkView(moreMenu: .settings) {
                SettingsView()
            }
            if let _ = viewModel.currentUser {
                SFOMListItemLinkView(moreMenu: .activity) {
                    MyActivityView()
                }
                SFOMListItemView(moreMenu: .signOut) {
                    isSignOut = true
                }
            }
        }
        .listRowSeparator(.hidden)
    }
    
    var contentStudioItem: some View {
        VStack {
            ContentStudio()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
