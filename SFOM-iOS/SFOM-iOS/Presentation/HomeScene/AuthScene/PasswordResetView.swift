//
//  PasswordResetView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/22.
//

import SwiftUI
import Combine
import AlertToast

final class PasswordResetViewModel: ViewModel {
    private let authUseCase: AuthUseCase = AppContainer.shared.authUseCase
    
    @Published var email: String = ""
    @Published var result: Bool?
    
    private var cancellable = Set<AnyCancellable>()
    
    deinit{
        cancellable.removeAll()
    }
    
    func resetPassword(){
        result = nil
        authUseCase.resetPassword(email: email)
            .map { result -> Bool? in result }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: \.result, on: self)
            .store(in: &cancellable)
    }
}

struct PasswordResetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: PasswordResetViewModel = PasswordResetViewModel()
    
    @State private var resetPasswordSuccess: Bool = false
    @State private var resetPasswordFail: Bool = false
    
    var body: some View {
        VStack {
            SFOMTextField(StringCollection.Auth.email.localized, text: $viewModel.email)
            SFOMAuthButton(StringCollection.PasswordResetView.resetPassword.localized) {
                viewModel.resetPassword()
            }
            HStack { Spacer()}
        }
        .padding()
        .onReceive(viewModel.$result) { result in
            if let result = result {
                if result {
                    resetPasswordSuccess = true
                } else {
                    resetPasswordFail = true
                }
            }
        }
        .toast(isPresenting: $resetPasswordSuccess,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(type: .complete(.accentColor),
                       title: StringCollection.PasswordResetView.resetPassword.localized,
                       subTitle: StringCollection.PasswordResetView.resetPasswordSuccess.localized)
        } completion: {
            dismiss()
        }
        .toast(isPresenting: $resetPasswordFail,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(type: .error(.red),
                       title:  StringCollection.PasswordResetView.resetPassword.localized,
                       subTitle: StringCollection.PasswordResetView.resetPasswordFail.localized)
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
