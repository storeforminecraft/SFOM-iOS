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
    let profileImage: String
    
    init(uid: String, nickname: String, profileImage: String) {
        self.uid = uid
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

extension UserDTO {
    func toDomain() -> User {
        return User(uid: uid,
                    nickname: nickname,
                    profileImage: profileImage)
    }
}
