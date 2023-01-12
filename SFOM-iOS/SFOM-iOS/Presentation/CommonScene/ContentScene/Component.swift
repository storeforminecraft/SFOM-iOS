//
//  Component.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/12.
//

import SwiftUI

public struct userCommentView<Destination>: View where Destination: View {
    private let userComment: UserComment
    private let action: (_ targetPath: String) -> Void
    private let targetPath: String
    @ViewBuilder private let destination:() -> Destination
    @State private var showDetailChildComment: Bool = false
    init(path: String, userComment: UserComment, action: @escaping (_ targetPath: String) -> Void, destination: @escaping () -> Destination) {
        self.userComment = userComment
        self.action = action
        self.destination = destination
        self.targetPath = "\(path)/comments/\(userComment.comment.id)"
    }
    
    public var body: some View {
        VStack(alignment:.leading, spacing: 8) {
            HStack(alignment: .top){
                NavigationLink {
                    destination()
                } label: {
                    SFOMImage(placeholder: Assets.Default.profile.image,
                              urlString: userComment.user.thumbnail)
                    .frame(width: 28, height: 28)
                    .cornerRadius(28)
                }
                
                VStack (alignment: .leading, spacing: 8){
                    HStack(alignment: .center){
                        NavigationLink {
                            ProfileView(uid: userComment.user.uid)
                        } label: {
                            Text(userComment.user.summary)
                                .font(.SFOMFont14.bold())
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Button {
                            action(targetPath)
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.SFOMFont14)
                                .foregroundColor(Color(.lightGray))
                        }
                    }
                    Text(userComment.comment.content)
                        .font(.SFOMFont12)
                        .foregroundColor(Color(.darkGray))
                    HStack{ Spacer() }
                }
                .padding()
                .background(Color(.lightGray).opacity(0.08))
                .cornerRadius(12)
            }
            VStack(alignment: .leading, spacing: 10) {
                ForEach(userComment.childComment[0..<min(userComment.childComment.count, 2)],
                        id: \.comment.id) { childComment in
                    Button {
                        showDetailChildComment.toggle()
                    } label: {
                        if showDetailChildComment {
                            userCommentView(path: targetPath, userComment: childComment) { chlildTargetPath in
                                action(chlildTargetPath)
                            } destination: {
                                ProfileView(uid: childComment.user.uid) as! Destination
                            }
                        } else {
                            HStack {
                                SFOMImage(placeholder: Assets.Default.profile.image,
                                          urlString: childComment.user.thumbnail)
                                .frame(width: 14, height: 14)
                                .cornerRadius(14)
                                Text(childComment.user.summary)
                                    .font(.SFOMFont10.bold())
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                Text(childComment.comment.content)
                                    .font(.SFOMFont10)
                                    .foregroundColor(Color(.darkGray))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }
            .padding(.leading, 42)
        }
    }
}
