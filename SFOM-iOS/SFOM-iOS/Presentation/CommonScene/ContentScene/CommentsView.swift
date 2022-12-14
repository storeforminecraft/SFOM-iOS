//
//  CommentsView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import SwiftUI
import Combine

// FIXME: showing Comments & Comment's Reply
final class CommentsViewModel: ViewModel {
    private let contentUseCase: ContentUseCase = AppContainer.shared.contentUseCase
    private var resource: Resource? = nil
    
    @Published var currentUser: User? = nil
    @Published var resourceComments: [UserComment] = []
    
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    deinit{
        cancellable.removeAll()
    }
    
    func bind(resource: Resource){
        self.resource = resource
        contentUseCase.fetchCurrentUserWithUidChanges()
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.currentUser = user
            })
            .store(in: &cancellable)
    }
    
    func fetchComments() {
        guard let resource = self.resource else { return }
        contentUseCase
            .fetchUserComment(resourceId: resource.id)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { resourceComments in
                self.resourceComments = resourceComments
                    .sorted { $0.comment.modifiedTimestamp > $1.comment.modifiedTimestamp }
            })
            .store(in: &cancellable)
    }
    
    func leaveComment(){
        
    }
    
}

struct CommentsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var commentsViewModel: CommentsViewModel = CommentsViewModel()
    let resource: Resource
    let userComments: [UserComment]
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text(StringCollection.ContentView.comments.localized)
                    .font(.SFOMFont16)
                    .foregroundColor(.black)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                         .font(.SFOMFont16)
                         .foregroundColor(.black)
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(resource: TestResource.resource, userComments: [])
    }
}
