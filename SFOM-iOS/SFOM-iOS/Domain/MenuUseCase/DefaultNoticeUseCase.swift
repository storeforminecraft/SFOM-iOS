//
//  DefaultNoticeUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import Combine

final class DefaultNoticeUseCase {
    private let noticeRepository: NoticeRepository
    
    init(noticeRepository: NoticeRepository) {
        self.noticeRepository = noticeRepository
    }
}

extension DefaultNoticeUseCase: NoticeUseCase {
    func fetchNotices() -> AnyPublisher<[Notice], Error> {
        noticeRepository.fetchNotices()
    }
}
