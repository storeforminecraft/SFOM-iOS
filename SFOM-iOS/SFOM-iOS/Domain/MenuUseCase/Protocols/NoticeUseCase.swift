//
//  NoticeUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import Foundation
import Combine

protocol NoticeUseCase {
    func fetchNotices() -> AnyPublisher<[Notice], Error>
}
