//
//  PolicyView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/21.
//

import SwiftUI

final class PolicyViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var userName: String = ""
}

struct PolicyView: View {
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.dismiss) var dismiss

    @ObservedObject private var viewModel: PolicyViewModel = PolicyViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: Localized.SignUpView.signUpTitle,
                       mainTitle: Localized.SignUpView.signUpMainTitle,
                       subTitle: Localized.SignUpView.signUpSubTitle)

            SFOMBackButton {
                dismiss()
            }

            Spacer()

            VStack (alignment: .center) {
                SFOMTextField(content: Localized.Auth.email, text: $viewModel.email)
                SFOMTextField(content: Localized.Auth.password, text: $viewModel.email, secure: true)
                SFOMTextField(content: Localized.Auth.passwordConfirm, text: $viewModel.passwordConfirm, secure: true)
                SFOMTextField(content: Localized.Auth.userName, text: $viewModel.userName)
            }

            Spacer()

            VStack (alignment: .center) {
                SFOMButton(Localized.SignUpView.signUpButtonTitle) {
                    #warning("add SignUp Action")
                }

                SFOMMarkdownText(Localized.Policy.policy2)
                    .font(.caption)
                    .foregroundColor(Color(.lightGray))
                    .multilineTextAlignment(.center)
            }
            HStack { Spacer() }
        }
            .navigationBarHidden(true)
            .padding(.top, 30)
            .padding(.horizontal, 25)
            .gesture(DragGesture().updating($dragOffset) { (value, state, transaction) in
            if (value.startLocation.x < 30 && value.translation.width > 100) {
                dismiss()
            }
        })
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}

