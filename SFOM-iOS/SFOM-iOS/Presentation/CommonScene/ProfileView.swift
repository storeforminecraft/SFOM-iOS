//
//  ProfileView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI
import Combine

// FIXME: - ProfileView: When Scroll, hide backgroundImage (GeometryReader)
final class ProfileViewModel: ViewModel {
    let profileUseCase: ProfileUseCase = AppContainer.shared.profileUseCase
    
    private var uid: String = ""
    
    @Published var currentUser: User? = nil
    @Published var user: User? = nil
    @Published var selected: Int = 0
    @Published var contents: [Resource] = []
    @Published var isLoading: Bool = false
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    deinit{
        cancellable.removeAll()
    }
    
    func bind(uid: String){
        self.uid = uid
        profileUseCase.fetchCurrentUserWithUidChanges()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.currentUser = user
            })
            .store(in: &cancellable)
        
        profileUseCase.fetchUser(uid: uid)
            .map { user -> User? in user }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.user, on: self)
            .store(in: &cancellable)
        
        $selected.sink { [weak self] contentCase in
            self?.isLoading = true
            switch contentCase {
            case 0:
                self?.uploadResources()
            case 1:
                self?.favoriteResources()
            default:
                self?.contents = []
            }
        }
        .store(in: &cancellable)
    }
    
    func uploadResources(){
        profileUseCase.fetchUserResources(uid: uid)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { contents in
                self.isLoading = false
                self.contents = contents
            })
            .store(in: &cancellable)
    }
    
    func favoriteResources(){
        profileUseCase.fetchUserFavoriteResources(uid: uid)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { contents in
                self.isLoading = false
                self.contents = contents
            })
            .store(in: &cancellable)
    }
}

struct ProfileView: View {
    @ObservedObject private var viewModel: ProfileViewModel = ProfileViewModel()
    
    private let uid: String
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    private let GridItemCount = 2
    private let spacing: CGFloat = 10
    private var cellWidth: CGFloat {
        let totalCellWidth = Int(screenWidth) - 10 - (Int(spacing) * (GridItemCount - 1))
        return CGFloat(totalCellWidth / GridItemCount)
    }
    
    private var columns: [GridItem] {
        return (0..<GridItemCount).compactMap { _ in
            GridItem(.fixed(cellWidth))
        }
    }
    
    init(uid: String) {
        self.uid = uid
        self.viewModel.bind(uid: uid)
    }
    
    var body: some View {
        VStack(spacing: 0){
            profile
            selectedCase
            SFOMIndicator(state: $viewModel.isLoading)
            contents
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    private var profile: some View {
        VStack{
            SFOMImage(placeholder: Assets.Default.profileBackground.image,
                      urlString: viewModel.user?.background)
            .aspectRatio(2, contentMode: .fit)
            SFOMImage(placeholder: Assets.Default.profile.image,
                      urlString: viewModel.user?.thumbnail)
            .frame(width: 105, height: 105)
            .cornerRadius(50)
            .overlay(Circle()
                .stroke(lineWidth: 5)
                .foregroundColor(.white))
            .padding(.top, -52.5)
            
            Text("\(viewModel.user?.nickname ?? "")")
                .font(.SFOMSmallFont)
                .foregroundColor(.black)
                .padding(.vertical, 5)
            
            // FIXME: - Localization
            Text("\(viewModel.user?.introduction ?? "아직 한 줄 소개가 입력되지 않았습니다.")")
                .font(.SFOMExtraSmallFont)
                .foregroundColor(Color(.darkGray))
                .padding(.horizontal)
                .padding(.bottom, 15)
        }
    }
    
    private var selectedCase: some View {
        HStack{
            Spacer()
            SFOMSelectedButton("upload",
                               tag: 0,
                               selectedIndex: $viewModel.selected)
            SFOMSelectedButton("favorite",
                               tag: 1,
                               selectedIndex: $viewModel.selected)
            Spacer()
        }
    }
    
    private var contents: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(viewModel.contents,
                        id: \.id) { resource in
                    VStack {
                        SFOMResourceItemView(resource: resource) {
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(uid: "7NxdOczSZNQBcOsyPmodEju2zFD2")
    }
}
