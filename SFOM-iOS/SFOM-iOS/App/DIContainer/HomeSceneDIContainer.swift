//
//  HomeSceneDIContainer.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import SwiftUI

final class HomeSceneDIConatiner {
    static let shared = HomeSceneDIConatiner()
    private init() { }
}

extension HomeSceneDIConatiner {
    
    @ViewBuilder
    func makeHomeView() -> some View {
        return HomeView()
    }
    
    @ViewBuilder
    func makeAuthView() -> some View {
        return AuthView()
    }
    
    @ViewBuilder
    func makeSignInView() -> some View {
        return SignInView()
    }
    
    @ViewBuilder
    func makeSignUpView() -> some View {
        return SignUpView()
    }
}
