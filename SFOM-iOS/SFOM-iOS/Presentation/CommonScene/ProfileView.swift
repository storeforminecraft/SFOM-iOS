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
            withAnimation {
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
    @State var showContent: Bool = false
    
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
        
        ObservingScrollView(showIndicators: false) {
            ZStack {
                Color.red.frame(height: 10)
                    .padding(.top, 426)
            VStack(spacing: 0){
                if !showContent {
                    profile
                }
                selectedCase
                SFOMIndicator(state: $viewModel.isLoading)
                contents
            }
            }
        }
        .top{ value in
            print(value)
        }
        .background(.blue)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    private var profile: some View {
        VStack{
            SFOMImage(placeholder: Assets.Default.profileBackground.image,
                      urlString: viewModel.user?.background)
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width, height: 180)
            .clipped()
            
            SFOMImage(placeholder: Assets.Default.profile.image,
                      urlString: viewModel.user?.thumbnail)
            .frame(width: 68, height: 68)
            .cornerRadius(34)
            .overlay(Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(.white))
            .padding(.top, -35)
            
            Text("\(viewModel.user?.nickname ?? "")")
                .font(.SFOMFont16)
                .foregroundColor(.black)
                .padding(.vertical, 5)
            
            // FIXME: - Localization
            Text("\(viewModel.user?.introduction ?? "아직 한 줄 소개가 입력되지 않았습니다.")")
                .font(.SFOMFont12)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.lightGray))
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
        .padding(.bottom, 8)
    }
    
    private var contents: some View {
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(uid: "7NxdOczSZNQBcOsyPmodEju2zFD2")
    }
}
