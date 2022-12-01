//
//  User.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import Foundation

struct User {
    let uid: String
    let nickname: String
    let profileImage: String
    
    init(uid: String, nickname: String, profileImage: String) {
        self.uid = uid
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
