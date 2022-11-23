//
//  HomeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI

fileprivate final class HomeViewModel: ObservableObject {

}

struct HomeView: View {
    var body: some View {
        VStack {
            homeNavigationBar
            ScrollView {

            }
        }
    }

    var homeNavigationBar: some View {
        HStack {
            Text(LocalizedString.homeTitle)
                .font(.SFOMTitleFont)
            Spacer()
            NavigationLink {
                // FIXME: - Push View
            } label: {
                ZStack (alignment: .topTrailing) {
                    Assets.moreMenu.push.image
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 2)
                        .padding(.vertical, 4)
                    // FIXME: - if push
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(.white, lineWidth: 4))
                }
            }

            // FIXME: - if SignIn
            Assets.default.profile.image
                .resizable()
                .frame(width: 42, height: 42)
                .cornerRadius(26)


            NavigationLink {
                // FIXME: - if SignIn
            } label: {
                Text(LocalizedString.signIn)
                    .font(.SFOMSmallFont)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(16)
                    .frame(height: 24)

            }
        }
            .padding(.horizontal, 22)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environment(\.locale, .init(identifier: "ko"))
            HomeView()
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
