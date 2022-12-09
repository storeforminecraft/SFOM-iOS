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

// MARK: - ViewBuilder
extension HomeSceneDIConatiner {
    
    @ViewBuilder
    func makeHomeView() -> some View {
        HomeView()
    }
    
    @ViewBuilder
    func makeAuthView() -> some View {
        AuthView()
    }
    
    @ViewBuilder
    func makeSignInView() -> some View {
        SignInView()
    }
    
    @ViewBuilder
    func makeSignUpView() -> some View {
        SignUpView()
    }
    
}
