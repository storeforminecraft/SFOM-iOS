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
    func fetchCommentEvent() -> AnyPublisher<[CommentEvent], Error> {
        guard let endPoint = NetworkEndPoints.shared.eventsTimeline() else {
            return Fail(error: NetworkEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: CommentEventDTO.self,
                                                whereFields: [.isEqualTo("eventType", value: "created:comment")],
                                                order: .descending("eventTimestamp"),
                                                limit: 10)
        .map { $0.map{ $0.toDomain() } }
        .eraseToAnyPublisher()
    }
}
