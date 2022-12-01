//
//  AuthView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var sharedData: SharedData {
        didSet {
            if sharedData.user != nil {
                dismiss()
            }
        }
    }

    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: LocalizedString.AuthView.authTitle,
                       mainTitle: LocalizedString.AuthView.authMainTitle,
                       subTitle: LocalizedString.AuthView.authSubTitle)

            Button {
                dismiss()
            } label: {
                HStack {
                    Assets.SystemIcon.backCircle.image
                    Text(LocalizedString.back)
                }
                    .font(.SFOMSmallFont)
                    .padding(.vertical, 5)
            }

            Spacer()

            VStack (alignment: .center) {
                
                SFOMNavigationLink(LocalizedString.AuthView.authSignInButtonTitle) {
                    SignInView()
                }
                
                SFOMNavigationLink(LocalizedString.AuthView.authSignUpButtonTitle, accent: false) {
                    SignUpView()
                }

                SFOMMarkdownText(LocalizedString.Policy.policy1)
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
