//
//  DefaultEventRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation
import Combine

final class DefaultCommentEventRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultCommentEventRepository: CommentEventRepository {
    func fetchCommentEvent() -> AnyPublisher<[CommentEvent], Error> {
        guard let endPoint = APIEndPoints.shared.eventsTimeline() else {
            return Fail(error: APIEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.readAllWithFilter(endPoint: endPoint,
                                                type: CommentEventDTO.self,
                                                whereFields: [.isEqualTo("eventType", value: "created:comment")],
                                                order: .descending("eventTimestamp"),
                                                limit: 10)
        .map { $0.map{ $0.toDomain() } }
        .handleEvents(receiveOutput: { events in
            print(events)
        }, receiveCompletion: { e in
            print(e)
        })
        .eraseToAnyPublisher()
    }
    
    func fetchCommentInfo(eventPath: String) -> AnyPublisher<Comment, Error> {
        let components = eventPath.components(separatedBy: "/").filter{ !["","resources","comments"].contains($0) }
        guard components.count == 2,
              let endPoint = APIEndPoints.shared.resourcesComments(doc: components[0], subDoc: components[1]) else {
            return Fail(error: APIEndPointError.wrongEndPointError).eraseToAnyPublisher()
        }
        return networkService.read(endPoint: endPoint, type: CommentDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    
}

