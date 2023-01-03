//
//  DefaultSearchUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Combine

final class DefaultSearchUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
}

extension DefaultSearchUseCase: SearchUseCase {
    func search(keyword: String, page: Int, tag: String?, sort: String?) -> AnyPublisher<[Resource], Error> {
        return searchRepository.search(keyword: keyword, page: page, tag: tag, sort: sort)
    }
}
