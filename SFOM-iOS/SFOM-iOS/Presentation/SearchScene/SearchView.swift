//
//  SearchView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchData: [Resource] = []
    @Published var isSearching: Bool = false
    @Published var pagenation: Int = 1
    @Published var tapReturn: Void = ()

    var cancelBag = Set<AnyCancellable>()

    init() {
        self.bind()
    }

    func bind() {
        $isSearching.sink { receive in
            if receive { self.search() }
            else { self.reset() }
        }.store(in: &cancelBag)
    }

    func reset() {
        self.searchData = []
        self.pagenation = 1
    }

    func search() {

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
        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                if !viewModel.isSearching {
                    Text(StringCollection.SearchView.searchTitle.localized)
                        .font(.SFOMTitleFont)
                }

                SFOMSearchBar(placeholder: StringCollection.SearchView.searchPlaceholder.localized,
                              text: $viewModel.searchText,
                              state: $viewModel.isSearching)

            }
                .padding()
            searchContents
            HStack { Spacer() }
        }
            .ignoresSafeArea(edges: .bottom)
    }

    var searchContents: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(viewModel.searchData,
                        id: \.id) { data in
                    VStack {
                        SFOMSearchItemView(resource: data,
                                           width: cellWidth) {
                            ContentView(resource: data)
                        }
                        HStack { Spacer() }
                    }
                }
            }
                .padding(.horizontal, 5)
                .padding(.bottom, 10)
            GeometryReader { proxy in
                let offset = proxy.frame(in: .named("scroll")).minY
                Color.clear
                    .preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
            }
        }
            .background(GeometryReader { proxy in
            Color.clear.onAppear { scrollViewHeight = proxy.size.height }
        })
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in

        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
