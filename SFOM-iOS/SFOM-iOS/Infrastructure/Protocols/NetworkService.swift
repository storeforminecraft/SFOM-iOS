//
//  NetworkService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

protocol NetworkService {
    func create<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error>
    func read<T: Decodable>(endPoint: FIREndPoint, type: T.Type) -> AnyPublisher<T, Error>
    func update<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error>
    func delete<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error>
    
    func readAll<T: Decodable>(endPoint: FIREndPoint, type: T.Type) -> AnyPublisher<[T], Error>
    func readAllWithFilter<T: Decodable>(endPoint: FIREndPoint, type: T.Type, whereFields: [WhereField]?, order: Order?, limit: Int?) -> AnyPublisher<[T], Error>
}
