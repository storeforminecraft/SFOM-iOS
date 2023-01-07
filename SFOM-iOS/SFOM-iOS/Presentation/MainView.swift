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
        TabView(selection: $selectedIndex) {
            tabViewBuilder{ HomeView() }
            .tag(0)
            tabViewBuilder{ SearchView() }
            .tag(1)
            tabViewBuilder{ MenuView() }
            .tag(2)
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
    }
    
    var tabBar: some View {
        HStack {
            Group {
                SFOMTabButton(kind: .home,
                              tag: 0,
                              selectedIndex: $selectedIndex)
                SFOMTabButton(kind: .search,
                              tag: 1,
                              selectedIndex: $selectedIndex)
                SFOMTabButton(kind: .menu,
                              tag: 2,
                              selectedIndex: $selectedIndex)
            }
            .frame(width: 24, height: 24)
            .padding(20)
        }
        .background(Color(.white))
        .cornerRadius(24)
        .shadow(color: .init(white: 0, opacity: 0.12), radius: 8, x: 0, y: 2)
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    func tabViewBuilder<Destination: View>(destination: @escaping () -> Destination) -> some View {
        NavigationView {
            destination()
                .overlay(alignment: .bottom) { tabBar }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
