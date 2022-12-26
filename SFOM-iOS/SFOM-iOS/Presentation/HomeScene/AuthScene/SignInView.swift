//
//  SignInView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import SwiftUI
import Combine
import AlertToast

final class SignInViewModel: ObservableObject {
    private let authUseCase: AuthUseCase = AppContainer.shared.authUseCase
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var result: Bool? = nil
    private var cancellable = Set<AnyCancellable>()
    
    func signIn(){
        result = nil
        authUseCase
            .signIn(email: email, password: password)
            .map { result -> Bool? in result }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: \.result, on: self)
            .store(in: &cancellable)
    }
}

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: SignInViewModel = SignInViewModel()
    
    @State private var isPresentPasswordReset: Bool = false
    @State private var isLoading: Bool = false
    @State private var signInFail: Bool = false
    
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
                    isLoading = true
                    viewModel.signIn()
                }
                
                Button {
                    isPresentPasswordReset = true
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
        .onReceive(viewModel.$result) { result in
            if let result = result {
                isLoading = false
                if result {
                    dismiss()
                } else {
                    signInFail = true
                }
            }
        }
        .toast(isPresenting: $isLoading) {
            AlertToast(type: .loading)
        }
        .toast(isPresenting: $signInFail,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(type: .error(.red),
                       title: Localized.SignInView.signIn,
                       subTitle: Localized.SignInView.signInFail)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

