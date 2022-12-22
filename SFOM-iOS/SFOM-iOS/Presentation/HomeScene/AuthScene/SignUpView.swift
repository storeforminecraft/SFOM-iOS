//
//  SignUpView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    private let authUseCase: AuthUseCase = AppContainer.shared.authUseCase
    
    @Published var disabled: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var userName: String = ""
    @Published var result: Bool? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
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
    
    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: Localized.SignUpView.signUpTitle,
                       mainTitle: Localized.SignUpView.signUpMainTitle,
                       subTitle: Localized.SignUpView.signUpSubTitle)
            SFOMBackButton {
                dismiss()
            }
            .padding(.top, 5)
            Spacer()
            VStack (alignment: .center) {
                SFOMTextField(Localized.Auth.email, text: $viewModel.email)
                SFOMTextField(Localized.Auth.password, text: $viewModel.email, secure: true)
                SFOMTextField(Localized.Auth.passwordConfirm, text: $viewModel.passwordConfirm, secure: true)
                SFOMTextField(Localized.Auth.userName, text: $viewModel.userName)
            }
            Spacer()
            VStack (alignment: .center) {
                SFOMButton(Localized.SignUpView.signUpButtonTitle) {
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
                if result {
                    dismiss()
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

