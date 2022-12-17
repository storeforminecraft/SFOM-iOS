//
//  ProtectedAuthUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/16.
//

import Combine

protocol ProtectedAuthUseCase {
    func withdrawal() -> AnyPublisher<Bool, Error>
}
