//
//  NetworkService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation

protocol NetworkService {
    func signIn(email: String, password: String)
    func signOut()
}
