//
//  SearchView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine
import Alamofire
import Kingfisher

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
        AF.request("https://asia-northeast3-storeforminecraft.cloudfunctions.net/v1/resources",
                   method: .get,
                   parameters: ["keyword": searchText,
                                "pagenation": pagenation],
                   encoding: URLEncoding.queryString)
            .responseDecodable(of: [SearchData].self) { response in
            if let reponseData = response.value {
                reponseData
                    .publisher
                    .flatMap { searchData in
                    FirebaseManager.shared.firestore.collection("resources")
                        .document(searchData.id)
                        .publisher(type: Resource.self)
                }.compactMap { $0 }
                    .sink { data in
                    self.searchData.append(data)
                }.store(in: &self.cancelBag)
            }
        }
    }
}

struct SearchView: View {
    @ObservedObject private var searchViewModel = SearchViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack (alignment: .leading) {
            if !searchViewModel.isSearching {
                Text(LocalizedString.SearchView.searchTitle)
                    .font(.SFOMTitleFont)
            }

            SFOMSearchBar(placeholder: LocalizedString.SearchView.searchPlaceholder,
                          text: $searchViewModel.searchText,
                          state: $searchViewModel.isSearching)
            searchContents
            HStack { Spacer() }
        }
            .padding()
            .ignoresSafeArea(edges: .bottom)
    }

    var searchContents: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(searchViewModel.searchData,
                        id: \.id) { data in
                    VStack {
                        HStack { Spacer() }
                        VStack {
                            if let thumbImage = data.images.first {
                                KFImage(URL(string:))
                            }
                        }

                    }.background(.blue)
                }
            }
                .background(.orange)
                .padding(.bottom, 10)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
