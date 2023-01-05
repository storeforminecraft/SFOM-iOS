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
    
    private var pageRecently: Int = 1
    @Published var isLoadingRecently: Bool = false
    @Published var searchResourcesRecently: [Resource] = []
    
    private var pageLikeCount: Int = 1
    @Published var isLoadingLikeCount: Bool = false
    @Published var searchResourcesLikeCount: [Resource] = []
    
    private var pageDownloads: Int = 1
    @Published var isLoadingDownloads: Bool = false
    @Published var searchResourcesDownloads: [Resource] = []
    
    @Published var isSearching: Bool = false
    @Published var tapReturn: Void = ()
    
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
        self.pageRecently = 1
        self.searchResourcesRecently = []
        self.pageLikeCount = 1
        self.searchResourcesLikeCount = []
        self.pageDownloads = 1
        self.searchResourcesDownloads = []
    }
    
    func searchRecently() {
        if isLoadingRecently || searchText == "" { return }
        isLoadingRecently = true
        searchUseCase.search(keyword: searchText,
                             page: pageRecently,
                             tag: nil,
                             sort: "modifiedTimestamp:desc")
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .sink { searchResourcesRecently in
            self.searchResourcesRecently.append(contentsOf: searchResourcesRecently
                .sorted(by: { $0.modifiedTimestamp > $1.modifiedTimestamp }))
            self.isLoadingRecently = false
            self.pageRecently += 1
        }
        .store(in: &cancellable)
    }
    
    func searchLikeCount() {
        if isLoadingLikeCount || searchText == "" { return }
        isLoadingLikeCount = true
        searchUseCase.search(keyword: searchText,
                             page: pageLikeCount,
                             tag: nil,
                             sort: "likeCount:desc")
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .sink { searchResourcesLikeCount in
            self.searchResourcesLikeCount.append(contentsOf: searchResourcesLikeCount
                .sorted(by: { $0.likeCount > $1.likeCount }))
            self.isLoadingLikeCount = false
            self.pageLikeCount += 1
        }
        .store(in: &cancellable)
    }
    
    func searchDownloads() {
        if isLoadingDownloads || searchText == "" { return }
        isLoadingDownloads = true
        searchUseCase.search(keyword: searchText,
                             page: pageDownloads,
                             tag: nil,
                             sort: "downloadCount:desc")
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .sink { searchResourcesDownloads in
            self.searchResourcesDownloads.append(contentsOf: searchResourcesDownloads
                .sorted(by: { $0.downloadCount > $1.downloadCount }))
            self.isLoadingDownloads = false
            self.pageDownloads += 1
        }
        .store(in: &cancellable)
    }
}

struct SearchView: View {
    @ObservedObject private var viewModel: SearchViewModel = SearchViewModel()
    let spacing: CGFloat = 10
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            searchBar
            searchContents
            HStack { Spacer() }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var searchBar: some View {
        VStack (alignment: .leading, spacing: 0) {
            if !viewModel.isSearching {
                Text(StringCollection.SearchView.searchTitle.localized)
                    .font(.SFOMTitleFont)
                    .frame(height: 20)
                    .padding(.vertical)
            }
            SFOMSearchBar(placeholder: StringCollection.SearchView.searchPlaceholder.localized,
                          text: $viewModel.searchText,
                          state: $viewModel.isSearching)
            if viewModel.isSearching {
                HStack(alignment: .center) {
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
                .frame(height: 20)
                .padding()
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var searchContents: some View {
        TabView (selection: $viewModel.selected){
            searchResourcesRecently
                .tag(0)
            searchResourcesLikes
                .tag(1)
            searchResourcesDownloads
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding(.top, -10)
    }
    
    @State private var offset: CGFloat = .zero
    @State private var viewHeight: CGFloat = .zero
    
    private var searchResourcesRecently: some View {
        VStack(spacing: 0){
            ObservingScrollView (showIndicators: true){
                LazyVGrid(columns: [.init(.flexible()),.init(.flexible())], spacing: spacing) {
                    ForEach(viewModel.searchResourcesRecently,
                            id: \.id) { resource in
                        SFOMResourceItemView(resource: resource){
                            ContentView(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .bottom { value in
                viewModel.searchRecently()
            }
        }
    }
    
    private var searchResourcesLikes: some View {
        VStack(spacing: 0){
            ObservingScrollView {
                LazyVGrid(columns: [.init(.flexible()),.init(.flexible())], spacing: spacing) {
                    ForEach(viewModel.searchResourcesLikeCount,
                            id: \.id) { resource in
                        SFOMResourceItemView(resource: resource){
                            ContentView(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .bottom { value in
                viewModel.searchLikeCount()
            }
        }
    }
    
    private var searchResourcesDownloads: some View {
        VStack(spacing: 0){
            ObservingScrollView {
                LazyVGrid(columns: [.init(.flexible()),.init(.flexible())], spacing: spacing) {
                    ForEach(viewModel.searchResourcesDownloads,
                            id: \.id) { resource in
                        SFOMResourceItemView(resource: resource){
                            ContentView(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .bottom { value in
                viewModel.searchDownloads()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
