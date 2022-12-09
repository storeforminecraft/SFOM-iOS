//
//  SearchSceneDIContainer.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/09.
//

import SwiftUI

final class SearchSceneDIContainer {
    static let shared = SearchSceneDIContainer()
    private init() { }
}

// MARK: - ViewBuilder
extension SearchSceneDIContainer {
    
    @ViewBuilder
    func makeSearchView() -> some View {
        SearchView()
    }
    
}

