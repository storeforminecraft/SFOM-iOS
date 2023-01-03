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
    @Published var searchResourcesRecently: [Resource] = []
    @Published var searchResourcesLikes: [Resource] = []
    @Published var searchResourcesDownloads: [Resource] = []
    @Published var isSearching: Bool = false
    @Published var page: Int = 1
    @Published var tapReturn: Void = ()
    @Published var isLoadingRecently: Bool = false
    @Published var selected: Int = 0
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        self.bind()
    }
    
    func bind() {
        $isSearching.sink { receive in
            if receive { self.searchRecently() }
            else { self.reset() }
        }.store(in: &cancellable)
    }
    
    func reset() {
        self.searchResourcesRecently = []
        self.searchResourcesLikes = []
        self.searchResourcesDownloads = []
        self.page = 1
    }
    
    func searchRecently() {
        isLoadingRecently = true
        searchUseCase.search(keyword: searchText, page: page, tag: nil, sort: nil)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { searchResourcesRecently in
                self.searchResourcesRecently = searchResourcesRecently
                    .sorted(by: { $0.createdTimestamp > $1.createdTimestamp })
                self.isLoadingRecently = false
            }
            .store(in: &cancellable)
    }
    
    func searchLikes() {
        
    }
    
    func searchDownloads() {
        
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
            if viewModel.isSearching {
                HStack {
                    SFOMSelectedButton("RECENTLY",
                                       tag: 0,
                                       selectedIndex: $viewModel.selected)
                    SFOMSelectedButton("LIKES",
                                       tag: 1,
                                       selectedIndex: $viewModel.selected)
                    SFOMSelectedButton("DOWNLOADS",
                                       tag: 2,
                                       selectedIndex: $viewModel.selected)
                }
                .padding()
            }
            
            TabView (selection: $viewModel.selected){
                searchResourcesRecently
                    .tag(0)
                searchResourcesRecently
                    .tag(1)
                searchResourcesRecently
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            HStack { Spacer() }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    var searchResourcesRecently: some View {
        VStack(spacing: 0){
            SFOMIndicator(state: $viewModel.isLoadingRecently)
                .frame(height: 2)
                .padding(.vertical,4)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(viewModel.searchResourcesRecently,
                            id: \.id) { resource in
                        VStack {
                            SFOMResourceItemView(resource: resource){
                                ContentView(resource: resource)
                            }
                            .frame(width: cellWidth)
                            HStack { Spacer() }
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 10)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
