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
    @GestureState private var dragOffset = CGSize.zero
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
            
            Spacer()
            
            VStack (alignment: .center) {
                SFOMTextField(content: Localized.Auth.email,
                              text: $viewModel.email)
                SFOMTextField(content: Localized.Auth.password,
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
        .gesture(DragGesture().updating($dragOffset) { (value, state, transaction) in
            if (value.startLocation.x < 30 && value.translation.width > 100) {
                dismiss()
            }
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

