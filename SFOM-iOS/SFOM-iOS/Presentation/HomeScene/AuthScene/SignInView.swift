//
//  SignInView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import SwiftUI

final class SignInViewModel: ObservableObject {
    private let authUseCase: AuthUseCase = AppContainer.shared.authUseCase
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPresentPasswordReset: Bool = false
    @Published var isPresentToast: Bool = false
    @Published var toastMessage: String = ""
    
    func signIn(){
        // authUseCase.signIn(email: email, password: password)
        // 결과 처리
    }
}


struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var viewModel: SignInViewModel = SignInViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: Localized.SignInView.signInTitle,
                       mainTitle: Localized.SignInView.signInMainTitle,
                       subTitle: Localized.SignInView.signInSubTitle)
            
            SFOMBackButton {
                dismiss()
            }
            .padding(.top, 5)
            
            Spacer()
            
            VStack (alignment: .center) {
                SFOMTextField(Localized.Auth.email,
                              text: $viewModel.email)
                SFOMTextField(Localized.Auth.password,
                              text: $viewModel.password,
                              secure: true)
            }
            Spacer()
            
            VStack (alignment: .center, spacing: 20) {
                SFOMButton(Localized.SignInView.signInButonTitle) {
                    
                }
                
                Button {
                    viewModel.isPresentPasswordReset = true
                } label: {
                    Text(Localized.SignInView.resetEmailButtonTitle)
                        .foregroundColor(Color(.lightGray))
                }
            }
            HStack { Spacer() }
        }
        .navigationBarHidden(true)
        .padding(.top, 30)
        .padding(.horizontal, 25)
        //     .toast(isPresenting: $isPresentToast) {
        //     AlertToast(displayMode: .alert, type: .regular, title: self.toastMessage)
        // }
        .popover(isPresented: $viewModel.isPresentPasswordReset) {
            // PasswordResetView()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

