//
//  UserComment.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import Foundation

struct UserComment {
    let user: User
    let comment: Comment
    let childComment: [UserComment]
    
    init(user: User, comment: Comment, childComment: [UserComment] = []) {
        self.user = user
        self.comment = comment
        self.childComment = childComment
    }
}
