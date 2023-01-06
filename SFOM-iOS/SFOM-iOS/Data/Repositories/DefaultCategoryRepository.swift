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
        let start = (page - 1 > 0 ? page - 1 : -1) * limit
        switch order {
        case .newest:
            guard let endPoint = NetworkEndPoints.shared.resources(doc: nil) else {
                return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
            }
            return fetchResources(endPoint: endPoint, category: category, orderItem: order.item, start: start, limit: limit)
        case .daily:
            guard let endPoint = NetworkEndPoints.shared.dailyRankdatas(doc: Date().yearToDayString) else {
                return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
            }
            return fetchRanksResources(endPoint: endPoint,
                                       category: category,
                                       orderItem: order.item,
                                       start: start,
                                       limit: limit)
        case .monthly:
            guard let endPoint = NetworkEndPoints.shared.monthlyRankdatas(doc: Date().yearToMonthString) else {
                return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
            }
            return fetchRanksResources(endPoint: endPoint,
                                       category: category,
                                       orderItem: order.item,
                                       start:start,
                                       limit: limit)
        }
    }
}

private extension DefaultCategoryRepository {
    func fetchResources(endPoint: FirestoreEndPoint, category: String, orderItem: String, start: Int, limit: Int) -> AnyPublisher<[Resource], Error> {
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: ResourceDTO.self,
                                                whereFields: [.isEqualTo("category", value: category)],
                                                order: .descending(orderItem),
                                                start: start,
                                                limit: limit)
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
    
    func fetchRanksResources(endPoint: FirestoreEndPoint, category: String, orderItem: String, start:Int, limit: Int) -> AnyPublisher<[Resource], Error>  {
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: RankDataDTO.self,
                                                whereFields: [.isEqualTo("category", value: category)],
                                                order: .descending(orderItem),
                                                start: start,
                                                limit: limit)
        .flatMap{ [weak self] rankDataDTOList -> AnyPublisher<[Resource], Error> in
            guard let self = self else { return Fail(error: UseCaseError.noObjectError).eraseToAnyPublisher() }
            return rankDataDTOList.publisher
                .flatMap { rankDataDTO -> AnyPublisher<Resource, Error> in
                    guard let endPoint = NetworkEndPoints.shared.resources(doc: rankDataDTO.id) else {
                        return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
                    }
                    return self.networkService.read(endPoint: endPoint, type: ResourceDTO.self)
                        .map{ $0.toDomain() }
                        .eraseToAnyPublisher()
                }
                .map{ resource -> Resource? in resource }
                .replaceError(with: nil)
                .compactMap{ $0 }
                .collect()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
