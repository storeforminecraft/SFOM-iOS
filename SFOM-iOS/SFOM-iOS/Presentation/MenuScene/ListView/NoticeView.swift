//
//  NoticeView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI
import Combine

final class NoticeViewModel: ViewModel {
    private let noticeUseCase: NoticeUseCase = AppContainer.shared.noticeUseCase
    
    @Published var notices: [Notice] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        bind()
    }
    
    func bind(){
        noticeUseCase.fetchNotices()
            .handleEvents(receiveOutput: { not in
                print(not)
            }, receiveCompletion: { error in
                print(error)
            })
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
        .navigationTitle(Localized.MoreMenu.notice)
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
