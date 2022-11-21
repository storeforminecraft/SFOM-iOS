//
//  MainView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/18.
//

import SwiftUI

struct MainView: View {
    @State private var selectedIndex: Int = 0

    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tag(0)
                SearchView()
                    .tag(1)
                MenuView()
                    .tag(2)
            }
                .overlay(alignment: .bottom) {
                tabBar
            }

        }
    }

    var tabBar: some View {
        HStack {
            Button {
                
            } label: {
                Assets.tabBar.home.image
            }
            Button {
                
            } label: {
                Assets.tabBar.search.image
            }
            Button {
                
            } label: {
                Assets.tabBar.menu.image
            }

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
