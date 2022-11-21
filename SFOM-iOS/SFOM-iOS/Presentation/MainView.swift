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
            TabView(selection: $selectedIndex) {
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
            Group {
                SFOMTabButton(kind: .home, tag: 0, selectedIndex: $selectedIndex)
                SFOMTabButton(kind: .search, tag: 1, selectedIndex: $selectedIndex)
                SFOMTabButton(kind: .menu, tag: 2, selectedIndex: $selectedIndex)
            }
                .frame(width: 40, height: 40)
        }
            .padding(.vertical,10)
            .padding(.horizontal, 20)
            .background(Color(.white))
            .cornerRadius(22)
            .shadow(radius: 2)
            .padding(.bottom, 20)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
