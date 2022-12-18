//
//  EventDTO+Mapping.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

struct CommentEventDTO: Codable {
    let eventPath: String
    let eventTimestamp: Date
    let eventType: String
}

extension CommentEventDTO {
    func toDomain() -> CommentEvent {
        CommentEvent(eventPath: eventPath,
                     eventTimestamp: eventTimestamp,
                     eventType: eventType)
    }
}

extension CommentEvent {
    func toDTO() -> CommentEventDTO {
        CommentEventDTO(eventPath: eventPath,
                        eventTimestamp: eventTimestamp,
                        eventType: eventType)
    }
}
