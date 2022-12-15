//
//  HTTPService.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Combine

protocol HTTPService {
    func get(endPoint: HTTPEndPoint)
    func post(endPoint: HTTPEndPoint)
}
