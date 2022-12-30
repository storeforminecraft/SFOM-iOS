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
}

struct AuthView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: AuthViewModel = AuthViewModel()
    @AppStorage("User") var currentUser: User? = UserDefaults.standard.object(forKey: "User") as? User

    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: Localized.AuthView.authTitle,
                       mainTitle: Localized.AuthView.authMainTitle,
                       subTitle: Localized.AuthView.authSubTitle)

            
            SFOMBackButton {
                dismiss()
            }
            .padding(.top, 5)

            Spacer()

            VStack (alignment: .center) {
                SFOMNavigationLink(Localized.AuthView.authSignUpButtonTitle, accent: false) {
                    PolicyView()
                }
                
                SFOMNavigationLink(Localized.AuthView.authSignInButtonTitle) {
                    SignInView()
                }

                SFOMMarkdownText(Localized.Policy.signInPolicy)
                    .font(.caption)
                    .foregroundColor(Color(.lightGray))
                    .multilineTextAlignment(.center)
            }
            HStack { Spacer() }
        }
            .navigationBarHidden(true)
            .padding(.top, 30)
            .padding(.horizontal, 25)
            .onChange(of: currentUser){ result in
                if result != nil {
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
