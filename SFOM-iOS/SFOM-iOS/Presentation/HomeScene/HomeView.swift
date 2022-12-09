//
//  HomeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            homeNavigationBar
            ScrollView {
                postItemsView
            }
            
        }
    }
    
    private var homeNavigationBar: some View {
        HStack(alignment: .center) {
            Text(LocalizedString.homeTitle)
                .font(.SFOMTitleFont)
            Spacer()
            // NavigationLink {
            //     // FIXME: - Push View
            // } label: {
            //     ZStack (alignment: .topTrailing) {
            //         Assets.moreMenu.push.image
            //             .resizable()
            //             .frame(width: 24, height: 24)
            //             .padding(.horizontal, 2)
            //             .padding(.vertical, 4)
            //         // FIXME: - if push
            //         Circle()
            //             .foregroundColor(.red)
            //             .frame(width: 12, height: 12)
            //             .overlay(Circle().stroke(.white, lineWidth: 4))
            //     }
            // }
            
            NavigationLink {
                // ProfileView(uid: user.uid)
            } label: {
                Assets.Default.profile.image
                    .resizable()
                    .frame(width: 42, height: 42)
                    .cornerRadius(26)
            }
            NavigationLink {
                AuthView()
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
        .padding()
    }
    
    private var postItemsView: some View {
        VStack {
            ForEach(homeViewModel.posts, id: \.id) { post in
                SFOMPostItemView(post: post) {
                    PostView(post: post)
                }
            }
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            HomeView()
                .environment(\.locale, .init(identifier: "ko"))
            HomeView()
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
