//
//  PasswordResetView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/22.
//

import SwiftUI

final class PasswordResetViewModel: ViewModel {
    private let authUseCase: AuthUseCase = AppContainer.shared.authUseCase
    
    @Published var email: String = ""
    @Published var result: Bool?
    
    func resetPassword(){
        // authUseCase
        print("resetPassword")
    }
}

struct PasswordResetView: View {
    @ObservedObject private var viewModel: PasswordResetViewModel = PasswordResetViewModel()
    
    var body: some View {
        VStack {
            SFOMTextField(Localized.Auth.email, text: $viewModel.email)
            SFOMButton() {
                viewModel.resetPassword()
            }
            HStack { Spacer()}
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
