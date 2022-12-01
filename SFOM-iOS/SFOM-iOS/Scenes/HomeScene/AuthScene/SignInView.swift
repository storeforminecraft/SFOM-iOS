//
//  SignInView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import SwiftUI

final class SignInViewModel: ObservableObject {
    @EnvironmentObject var sharedData: SharedData

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPresentPasswordReset: Bool = false
    @Published var isPresentToast: Bool = false
    @Published var toastMessage: String = ""


    func loginUser() {
        SFOMSecure.SaltPassword(email: self.email, password: self.password) { saltPassword in
            FirebaseManager.shared.auth.signIn(withEmail: self.email, password: saltPassword) { authDataResult, error in
                if let error = error {
                    self.toastMessage = error.localizedDescription
                    self.isPresentToast = true
                    return
                }
                
                FirebaseManager.shared.ref.child("users")
            }
        }
    }
}

struct SignInView: View {
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.dismiss) var dismiss

    @ObservedObject private var signInViewModel = SignInViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: LocalizedString.SignInView.SignInTitle, mainTitle: LocalizedString.SignInView.SignInMainTitle, subTitle: LocalizedString.SignInView.SignInSubTitle)

            Button {
                dismiss()
            } label: {
                HStack {
                    Assets.SystemIcon.back.image
                    Text(LocalizedString.back)
                }
                    .font(.SFOMSmallFont)
                    .padding(.vertical, 5)
            }

            Spacer()

            VStack (alignment: .center) {
                SFOMTextField(content: LocalizedString.Auth.Email, text: $signInViewModel.email)
                SFOMTextField(content: LocalizedString.Auth.Password, text: $signInViewModel.password, secure: true)
            }
            Spacer()

            VStack (alignment: .center, spacing: 20) {
                SFOMButton(LocalizedString.SignInView.SignInButonTitle) {
                    signInViewModel.loginUser()
                }

                Button {
                    signInViewModel.isPresentPasswordReset = true
                } label: {
                    Text(LocalizedString.SignInView.ResetEmailButtonTitle)
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
        .popover(isPresented: $signInViewModel.isPresentPasswordReset) {
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

