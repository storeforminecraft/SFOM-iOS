//
//  SignUpView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI

final class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var userName: String = ""


}

struct SignUpView: View {
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.dismiss) var dismiss

    @ObservedObject private var signUpViewModel = SignUpViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: LocalizedString.SignUpView.signUpTitle,
                       mainTitle: LocalizedString.SignUpView.signUpMainTitle,
                       subTitle: LocalizedString.SignUpView.signUpSubTitle)

            Button {
                dismiss()
            } label: {
                HStack {
                    Assets.SystemIcon.backCircle.image
                    Text(LocalizedString.back)
                }.padding(.vertical)
            }

            Spacer()

            VStack (alignment: .center) {
                SFOMTextField(content: LocalizedString.Auth.email, text: $signUpViewModel.email)
                SFOMTextField(content: LocalizedString.Auth.password, text: $signUpViewModel.email, secure: true)
                SFOMTextField(content: LocalizedString.Auth.passwordConfirm, text: $signUpViewModel.passwordConfirm, secure: true)
                SFOMTextField(content: LocalizedString.Auth.userName, text: $signUpViewModel.userName)
            }

            Spacer()

            VStack (alignment: .center) {
                SFOMButton(LocalizedString.SignUpView.signUpButtonTitle) {
                    #warning("add SignUp Action")
                }

                SFOMMarkdownText(LocalizedString.Policy.policy2)
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

