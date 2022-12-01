//
//  SearchView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchData: [String] = []
    @Published var isSearching: Bool = false {
        didSet {
            if !isSearching {
                searchData = []
            }
        }
    }

    func search() {
        
    }

}

struct SearchView: View {
    @ObservedObject private var searchViewModel = SearchViewModel()

    var body: some View {
        VStack (alignment: .leading) {
            if !searchViewModel.isSearching {
                Text(LocalizedString.SearchView.searchTitle)
                    .font(.SFOMTitleFont)
            }

            SFOMSearchBar(placeholder: LocalizedString.SearchView.searchPlaceholder,
                          text: $searchViewModel.searchText,
                          state: $searchViewModel.isSearching) {

            }

            Spacer()
            HStack { Spacer() }
        }
            .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
