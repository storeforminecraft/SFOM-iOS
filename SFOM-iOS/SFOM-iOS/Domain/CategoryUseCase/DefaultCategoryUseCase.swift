//
//  DefaultCategoryUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Combine

final class DefaultCategoryUseCase {
    private let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
}

extension DefaultCategoryUseCase: CategoryUseCase{
    func fetchCategory(category: SFOMCategory, order: SFOMOrderItem, page: Int, limit: Int) -> AnyPublisher<[Resource], Error> {
        self.categoryRepository.fetchCategory(category: category.rawValue, order: order, page: page, limit: limit)
    }
}
