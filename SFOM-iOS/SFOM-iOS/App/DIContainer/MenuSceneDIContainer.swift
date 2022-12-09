//
//  MenuSceneDIContainer.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import SwiftUI

final class MenuSceneDIContainer {
    static let shared = MenuSceneDIContainer()
    private init() { }
}

// MARK: - ViewBuilder
extension MenuSceneDIContainer {
    
    @ViewBuilder
    func makeMenuView() -> some View {
        MenuView()
    }
    
}
