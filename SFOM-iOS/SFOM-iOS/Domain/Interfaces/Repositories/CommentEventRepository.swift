//
//  EventRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Combine

protocol CommentEventRepository {
    func fetchCommentEvent() -> AnyPublisher<[CommentEvent], Error>
    func fetchCommentInfo(eventPath: String) -> AnyPublisher<Comment, Error>
}
