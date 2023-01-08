//
//  SignUpView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI
import Combine
import AlertToast

final class SignUpViewModel: ObservableObject {
    private let authUseCase: AuthUseCase = AppContainer.shared.authUseCase
    
    @Published var disabled: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var userName: String = ""
    @Published var result: Bool? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    deinit{
        cancellable.removeAll()
    }
    
    func signOut(){
        result = nil
        authUseCase.signUp(email: email, password: password, userName: userName)
            .map { result -> Bool? in result }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: \.result, on: self)
            .store(in: &cancellable)
    }
}

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: SignUpViewModel = SignUpViewModel()
    
    @State private var isLoading: Bool = false
    @State private var signUpFail: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: StringCollection.SignUpView.signUpTitle.localized,
                       mainTitle: StringCollection.SignUpView.signUpMainTitle.localized,
                       subTitle: StringCollection.SignUpView.signUpSubTitle.localized)
            
            SFOMBackButton {
                dismiss()
            }
            .padding(.top, 5)
            
            Spacer()
            VStack (alignment: .center) {
                SFOMTextField(StringCollection.Auth.email.localized, text: $viewModel.email)
                SFOMTextField(StringCollection.Auth.password.localized, text: $viewModel.password, secure: true)
                SFOMTextField(StringCollection.Auth.passwordConfirm.localized, text: $viewModel.passwordConfirm, secure: true)
                SFOMTextField(StringCollection.Auth.userName.localized, text: $viewModel.userName)
            }
            Spacer()
            VStack (alignment: .center) {
                SFOMAuthButton(StringCollection.SignUpView.signUpButtonTitle.localized) {
                    isLoading = true
                    viewModel.signOut()
                }
            }
            HStack { Spacer() }
        }
        .navigationBarHidden(true)
        .padding(.top, 30)
        .padding(.horizontal, 25)
        .onReceive(viewModel.$result) { result in
            if let result = result {
                isLoading = false
                if result {
                    dismiss()
                } else {
                    signUpFail = true
                }
            }
        }
        .toast(isPresenting: $isLoading) {
            AlertToast(type: .loading)
        }
        .toast(isPresenting: $signUpFail,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(type: .error(.red),
                       title: StringCollection.SignInView.signIn.localized,
                       subTitle: StringCollection.SignInView.signInFail.localized)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

