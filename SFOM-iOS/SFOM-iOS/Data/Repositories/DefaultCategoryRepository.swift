//
//  DefaultCategoryRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Foundation
import Combine

final class DefaultCategoryRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultCategoryRepository: CategoryRepository {
    func fetchCategory(category: String, order: SFOMOrderItem, page: Int, limit: Int) -> AnyPublisher<[Resource], Error> {
        switch order {
        case .newest:
            guard let endPoint = NetworkEndPoints.shared.resources(doc: nil) else {
                return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
            }
            return fetchResources(endPoint: endPoint, category: category, orderItem: order.item, limit: limit)
        case .daily:
            guard let endPoint = NetworkEndPoints.shared.dailyRankdatas(doc: Date().yearToDayString) else {
                return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
            }
            return fetchRanksResources(endPoint: endPoint, category: category, orderItem: order.item, limit: limit)
        case .monthly:
            guard let endPoint = NetworkEndPoints.shared.monthlyRankdatas(doc: Date().yearToMonthString) else {
                return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
            }
            return fetchRanksResources(endPoint: endPoint, category: category, orderItem: order.item, limit: limit)
        }
       
    }
}

private extension DefaultCategoryRepository {
    func fetchResources(endPoint: FirestoreEndPoint, category: String, orderItem: String, limit: Int) -> AnyPublisher<[Resource], Error> {
        return networkService.readAllWithFilter(endPoint: endPoint,
                                         type: ResourceDTO.self,
                                         whereFields: [.isEqualTo("category", value: category)],
                                         order: .descending(orderItem),
                                         limit: limit)
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
    
    func fetchRanksResources(endPoint: FirestoreEndPoint, category: String, orderItem: String, limit: Int) -> AnyPublisher<[Resource], Error>  {
        return networkService.readAllWithFilter(endPoint: endPoint,
                                         type: ResourceDTO.self,
                                         whereFields: [.isEqualTo("category", value: category)],
                                         order: .descending(orderItem),
                                         limit: limit)
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
}
