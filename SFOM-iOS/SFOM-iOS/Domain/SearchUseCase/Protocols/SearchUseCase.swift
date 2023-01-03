//
//  SearchUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Combine

protocol SearchUseCase {
    func search(keyword: String, page: Int, tag: String?, sort: String?) -> AnyPublisher<[Resource], Error>
}
