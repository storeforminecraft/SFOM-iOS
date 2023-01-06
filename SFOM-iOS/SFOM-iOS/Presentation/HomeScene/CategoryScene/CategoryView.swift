//
//  CategoryView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI
import Combine

final class CategoryViewModel: ViewModel {
    private let categoryUseCase: CategoryUseCase = AppContainer.shared.categoryUseCase
    private var category: SFOMCategory!
    
    @Published var searchText: String = ""
    
    private var pageNewest: Int = 1
    @Published var isLoadingNewest: Bool = false
    @Published var fetchResourcesNewest: [Resource] = []
    
    private var pageDaily: Int = 1
    @Published var isLoadingDaily: Bool = false
    @Published var fetchResourcesDaily: [Resource] = []
    
    private var pageMonthly: Int = 1
    @Published var isLoadingMonthly: Bool = false
    @Published var fetchResourcesMonthly: [Resource] = []
    
    var cancellable = Set<AnyCancellable>()
    
    deinit{
        print("\(Date()) \(category.rawValue) 🍎categoryView deinit")
    }
    
    func set(category: SFOMCategory) {
        self.category = category
    }
    
    func fetchNewest(){
        categoryUseCase.fetchCategory(category: category, order: .newest, page: pageNewest, limit: 20)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { fetchResourcesNewest in
                self.fetchResourcesNewest.append(contentsOf: fetchResourcesNewest
                    .sorted(by: { $0.modifiedTimestamp > $1.modifiedTimestamp }))
                self.isLoadingNewest = false
                self.pageNewest += 1
            }
            .store(in: &cancellable)
    }
    
    func fetchDaily(){
        categoryUseCase.fetchCategory(category: category, order: .daily, page: pageDaily, limit: 20)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { fetchResourcesDaily in
                self.fetchResourcesDaily.append(contentsOf: fetchResourcesDaily
                    .sorted(by: { $0.modifiedTimestamp > $1.modifiedTimestamp }))
                self.isLoadingDaily = false
                self.pageDaily += 1
            }
            .store(in: &cancellable)
    }
    
    func fetchMonthly(){
        categoryUseCase.fetchCategory(category: category, order: .monthly, page: pageMonthly, limit: 20)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { fetchResourcesMonthly in
                self.fetchResourcesMonthly.append(contentsOf: fetchResourcesMonthly
                    .sorted(by: { $0.modifiedTimestamp > $1.modifiedTimestamp }))
                self.isLoadingMonthly = false
                self.pageMonthly += 1
            }
            .store(in: &cancellable)
    }
}

struct CategoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: CategoryViewModel = CategoryViewModel()
    @State var selected: Int = 0
    
    private let category: SFOMCategory
    private let detailCategories: [SFOMDetailCategory]
    @State var selectedDetailCategory: SFOMDetailCategory = .all
    
    init(category: SFOMCategory) {
        self.category = category
        let detailCategories = category.detailCategories
        self.detailCategories = detailCategories
        self.selectedDetailCategory = detailCategories.first ?? .all
        viewModel.set(category: category)
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            selectBar
            categoryResourcesNewest
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack (alignment: .center, spacing: 4){
                    Button{
                        dismiss()
                    } label: {
                        HStack(spacing: 2){
                            Group {
                                Image(systemName: "chevron.backward")
                                    .font(.SFOMSmallFont.bold())
                                Text(self.category.localized)
                                    .font(.SFOMMediumFont.bold())
                            }
                            .foregroundColor(.black)
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Text(selectedDetailCategory.localized.uppercased())
                            .font(.SFOMExtraSmallFont.bold())
                            .foregroundColor(.black)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                            .overlay (RoundedRectangle(cornerRadius: 6)
                                .stroke(lineWidth: 1)
                                .foregroundColor(Color(.lightGray).opacity(0.4)))
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    // FIXME: - Search View
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }
    
    private var selectBar: some View {
        HStack(alignment: .center) {
            SFOMSelectedButton("최신순", tag: 0, selectedIndex: $selected)
            SFOMSelectedButton("주간", tag: 1, selectedIndex: $selected)
            SFOMSelectedButton("월간", tag: 2, selectedIndex: $selected)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private var categoryContents: some View {
        TabView (selection: $selected){
            categoryResourcesNewest
                .tag(0)
            categoryResourcesNewest
                .tag(1)
            categoryResourcesNewest
                .tag(2)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding(.top, -10)
    }
    
    private var categoryResourcesNewest: some View {
        VStack(spacing: 0){
            SFOMIndicator(state: $viewModel.isLoadingNewest)
            ObservingScrollView {
                LazyVGrid(columns: [.init(.flexible())]) {
                    ForEach(viewModel.fetchResourcesNewest,
                            id: \.id) { resource in
                        SFOMResourceItemView(resource: resource){
                            ContentView(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .bottom { value in
                viewModel.fetchNewest()
            }
        }
    }
    
    private var categoryResourcesDaily: some View {
        VStack(spacing: 0){
            SFOMIndicator(state: $viewModel.isLoadingDaily)
            ObservingScrollView {
                LazyVGrid(columns: [.init(.flexible())]) {
                    ForEach(viewModel.fetchResourcesNewest,
                            id: \.id) { resource in
                        SFOMResourceItemView(resource: resource){
                            ContentView(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .bottom { value in
                viewModel.fetchDaily()
            }
        }
    }
    
    private var categoryResourcesMonthly: some View {
        VStack(spacing: 0){
            SFOMIndicator(state: $viewModel.isLoadingMonthly)
            ObservingScrollView {
                LazyVGrid(columns: [.init(.flexible())]) {
                    ForEach(viewModel.fetchResourcesMonthly,
                            id: \.id) { resource in
                        SFOMResourceItemView(resource: resource){
                            ContentView(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .bottom { value in
                viewModel.fetchMonthly()
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .addon)
    }
}
