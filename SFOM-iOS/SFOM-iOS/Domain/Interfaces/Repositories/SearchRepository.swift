//
//  SearchRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Combine

protocol SearchRepository {
    func search(keyword: String, page: Int, tag: String?, sort: String?) -> AnyPublisher<[Resource],Error>
}
