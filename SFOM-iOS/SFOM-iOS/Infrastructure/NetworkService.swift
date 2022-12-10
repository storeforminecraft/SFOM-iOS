//
//  NetworkService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

protocol NetworkService {
    var uid: CurrentValueSubject<String?, Never> { get }
    func signIn(email: String, password: String)
    func signOut()
    func withdrawal()
    func create<T: DTO>(endPoint: EndPoint, dto: T)
    func read<T: DTO>(endPoint: EndPoint, dto: T)
    func update<T: DTO>(endPoint: EndPoint, dto: T)
    func delete<T: DTO>(endPoint: EndPoint, dto: T)
}
