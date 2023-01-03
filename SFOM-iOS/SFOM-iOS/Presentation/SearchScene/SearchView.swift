//
//  SearchView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    private let searchUseCase: SearchUseCase = AppContainer.shared.searchUseCase
    
    @Published var searchText: String = ""
    @Published var searchResources: [Resource] = []
    @Published var isSearching: Bool = false
    @Published var page: Int = 1
    @Published var tapReturn: Void = ()
    @Published var isLoading: Bool = false
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        self.bind()
    }
    
    func bind() {
        $isSearching.sink { receive in
            if receive { self.search() }
            else { self.reset() }
        }.store(in: &cancellable)
    }
    
    func reset() {
        self.searchResources = []
        self.page = 1
    }
    
    func search() {
        isLoading = true
        searchUseCase.search(keyword: searchText, page: page, tag: nil, sort: nil)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { searchResources in
                self.searchResources = searchResources
                self.isLoading = false
            }
            .store(in: &cancellable)
    }
}

struct SearchView: View {
    @ObservedObject private var viewModel: SearchViewModel = SearchViewModel()
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let GridItemCount = 2
    let spacing: CGFloat = 10
    var cellWidth: CGFloat {
        let totalCellWidth = Int(screenWidth) - 10 - (Int(spacing) * (GridItemCount - 1))
        return CGFloat(totalCellWidth / GridItemCount)
    }
    var columns: [GridItem] {
        return (0..<GridItemCount).compactMap { _ in
            GridItem(.fixed(cellWidth))
        }
    }
    
    @State private var scrollViewHeight: CGFloat = .zero
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            VStack (alignment: .leading) {
                if !viewModel.isSearching {
                    Text(StringCollection.SearchView.searchTitle.localized)
                        .font(.SFOMTitleFont)
                }
                
                SFOMSearchBar(placeholder: StringCollection.SearchView.searchPlaceholder.localized,
                              text: $viewModel.searchText,
                              state: $viewModel.isSearching)
                
            }
            .padding(.horizontal)
            .padding(.top)
            SFOMIndicator(state: $viewModel.isLoading)
                .frame(height: 2)
                .padding(.vertical,4)
            searchContents
            HStack { Spacer() }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    var searchContents: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(viewModel.searchResources,
                        id: \.id) { resource in
                    VStack {
                        SFOMResourceItemView(resource: resource){
                            ContentView(resource: resource)
                        }
                        .frame(width: cellWidth)
                        
                        // SFOMSearchItemView(resource: resource,
                        //                    width: cellWidth) {
                        //     ContentView(resource: resource)
                        // }
                        HStack { Spacer() }
                    }
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
