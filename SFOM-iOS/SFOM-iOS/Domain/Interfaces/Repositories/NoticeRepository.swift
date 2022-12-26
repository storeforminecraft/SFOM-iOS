//
//  NoticeRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import Foundation
import Combine

protocol NoticeRepository {
    func fetchNotice() -> AnyPublisher<Notice, Error>
}
