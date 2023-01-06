//
//  CategoryRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Combine

protocol CategoryRepository {
    func fetchCategory(category: String, order: SFOMOrderItem, page: Int, limit: Int) -> AnyPublisher<[Resource], Error>
}
