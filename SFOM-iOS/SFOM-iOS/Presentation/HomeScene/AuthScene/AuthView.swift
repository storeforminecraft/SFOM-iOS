//
//  AuthView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {
    private let authUseCase: AuthUseCase = AppContainer.shared.authUseCase
    @Published var isSignIn: Bool? = nil
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        bind()
    }
    
    func bind(){
        authUseCase
            .uidChanges()
            .map{ uid -> Bool? in uid != nil }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.isSignIn = result
            })
            .store(in: &cancellable)
    }
    
    deinit{
        cancellable.removeAll()
    }
}

struct AuthView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: AuthViewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: StringCollection.AuthView.authTitle.localized,
                       mainTitle: StringCollection.AuthView.authMainTitle.localized,
                       subTitle: StringCollection.AuthView.authSubTitle.localized)
            
            
            SFOMBackButton {
                dismiss()
            }
            .padding(.top, 5)
            
            Spacer()
            
            VStack (alignment: .center) {
                SFOMNavigationLink(StringCollection.AuthView.authSignUpButtonTitle.localized, accent: false) {
                    PolicyView()
                }
                
                SFOMNavigationLink(StringCollection.AuthView.authSignInButtonTitle.localized) {
                    SignInView()
                }
                
                SFOMMarkdownText(StringCollection.Policy.signInPolicy.localized)
                    .font(.caption)
                    .foregroundColor(Color(.lightGray))
                    .multilineTextAlignment(.center)
            }
            HStack { Spacer() }
        }
        .navigationBarHidden(true)
        .padding(.top, 30)
        .padding(.horizontal, 25)
        .onReceive(viewModel.$isSignIn) { result in
            if let result = result, result {
                dismiss()
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
