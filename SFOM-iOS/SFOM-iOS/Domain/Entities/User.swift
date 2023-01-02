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
    let introduction: String?
    let profileImage: String?
    let profileBackgroundImage: String?
    
    var summary: String {
        return "\(nickname.strip) (\(uid.prefix(6)))"
    }
    
    var thumbnail: String? {
        guard let profileImage = profileImage else { return nil }
        return "\(URLStringManager.urlString(key: .imageURL))/\(profileImage)"
    }
    
    init(uid: String, nickname: String, introduction: String?, profileImage: String?, profileBackgroundImage: String?) {
        self.uid = uid
        self.nickname = nickname
        self.introduction = introduction
        self.profileImage = profileImage
        self.profileBackgroundImage = profileBackgroundImage
    }
}
