//
//  CategoryUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Combine

protocol CategoryUseCase {
    func fetchCategory(category: SFOMCategory, order: SFOMOrderItem, page: Int, limit: Int) -> AnyPublisher<[Resource], Error>
}
