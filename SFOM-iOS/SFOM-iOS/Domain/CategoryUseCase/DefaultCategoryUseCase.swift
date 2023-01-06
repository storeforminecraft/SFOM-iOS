//
//  DefaultCategoryUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/06.
//

import Foundation

final class DefaultCategoryUseCase {
    private let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
}
