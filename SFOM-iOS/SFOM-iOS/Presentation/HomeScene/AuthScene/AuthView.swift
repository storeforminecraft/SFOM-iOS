//
//  AuthView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI

struct AuthView: View {
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: Localized.AuthView.authTitle,
                       mainTitle: Localized.AuthView.authMainTitle,
                       subTitle: Localized.AuthView.authSubTitle)

            
            SFOMBackButton {
                dismiss()
            }

            Spacer()

            VStack (alignment: .center) {
                SFOMNavigationLink(Localized.AuthView.authSignInButtonTitle) {
                    SignInView()
                }
                
                SFOMNavigationLink(Localized.AuthView.authSignUpButtonTitle, accent: false) {
                    SignUpView()
                }

                SFOMMarkdownText(Localized.Policy.policy1)
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

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
