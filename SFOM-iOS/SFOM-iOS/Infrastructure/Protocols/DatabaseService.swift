//
//  DatabaseService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/22.
//

import Foundation
import Combine

protocol DatabaseService {
    func setValue(endPoint: DatabaseEndPoint, value: [String: Any?]) -> AnyPublisher<Bool, Error>
    func getData(endPoint: DatabaseEndPoint) -> AnyPublisher<[String: Any?]?, Error>
    func observeSingleEvent(endPoint: DatabaseEndPoint) -> AnyPublisher<[String: Any?]?, Error>
}
