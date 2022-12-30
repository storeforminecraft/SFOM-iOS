//
//  MenuUseCase.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import Combine

protocol MenuUseCase {
    func signOut() -> AnyPublisher<Bool, Error>
}
