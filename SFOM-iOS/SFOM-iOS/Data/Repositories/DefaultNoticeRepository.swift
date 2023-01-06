//
//  DefaultNoticeRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import Foundation
import Combine

final class DefaultNoticeRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultNoticeRepository: NoticeRepository {
    func fetchNotices() -> AnyPublisher<[Notice], Error>{
        guard let endPoint = NetworkEndPoints.shared.notice() else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: NoticeDTO.self,
                                                order: .descending("modifiedTimestamp"))
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
}
