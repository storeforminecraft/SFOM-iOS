//
//  NoticeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI
import Combine

// MARK: - NoticeView
final class NoticeViewModel: ViewModel {
    private let noticeUseCase: NoticeUseCase = AppContainer.shared.noticeUseCase
    
    @Published var notices: [Notice] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        bind()
    }
    
    func bind(){
        noticeUseCase.fetchNotices()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.notices, on: self)
            .store(in: &cancellable)
    }
    
}

struct NoticeView: View {
    @ObservedObject var viewModel: NoticeViewModel = NoticeViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(viewModel.notices, id: \.id) { notice in
                    SFOMNoticeItemView(notice: notice)
                }
            }
            .padding()
        }
        .navigationTitle(StringCollection.MoreMenu.notice.localized)
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
