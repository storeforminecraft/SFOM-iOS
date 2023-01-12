//
//  NetworkService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Combine

// MARK: - NetworkService
protocol NetworkService {
    func create<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error>
    func read<T: Decodable>(endPoint: FIREndPoint, type: T.Type) -> AnyPublisher<T, Error>
    func update<T: Encodable>(endPoint: FIREndPoint, dto: T) -> AnyPublisher<T, Error>
    func delete(endPoint: FIREndPoint) -> AnyPublisher<Bool, Error>
    
    func readAll<T: Decodable>(endPoint: FIREndPoint, type: T.Type) -> AnyPublisher<[T], Error>
    func readAllWithFilter<T: Decodable>(endPoint: FIREndPoint,
                                         type: T.Type,
                                         whereFields: [WhereField]?,
                                         order: Order?,
                                         start: Int?,
                                         limit: Int?) -> AnyPublisher<[T], Error>
}

// MARK: - Default Value
extension NetworkService {
    func readAllWithFilter<T: Decodable>(endPoint: FIREndPoint,
                                         type: T.Type,
                                         whereFields: [WhereField]? = nil,
                                         order: Order? = nil,
                                         start: Int? = nil,
                                         limit: Int? = nil) -> AnyPublisher<[T], Error> {
        readAllWithFilter(endPoint: endPoint,
                          type: type,
                          whereFields: whereFields,
                          order: order,
                          start: start,
                          limit: limit)
    }
}
