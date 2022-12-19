//
//  UserDTO+Mapping.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Foundation

struct UserDTO: Codable {
    let uid: String
    let nickname: String
    let introduction: String?
    let profileImage: String?
    let profileBackgroundImage: String?
    
    init(uid: String, nickname: String, introduction: String?, profileImage: String?, profileBackgroundImage: String?) {
        self.uid = uid
        self.nickname = nickname
        self.introduction = introduction
        self.profileImage = profileImage
        self.profileBackgroundImage = profileBackgroundImage
    }
}


extension UserDTO {
    func toDomain() -> User {
        return User(uid: uid,
                    nickname: nickname,
                    introduction: introduction,
                    profileImage: profileImage,
                    profileBackgroundImage: profileBackgroundImage)
    }
}
