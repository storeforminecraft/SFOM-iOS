//
//  DIContainer.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import Foundation

// MARK: - Temp Container
final class AppContainer {
    static let shared = AppContainer()
    private init() { }
    
    let networkService: NetworkService = FirebaseService.shared
    let httpService: HTTPService = DefaultHTTPService()
    let networkAuthService = FirebaseService.shared as NetworkAuthService
    
    lazy var authRepository: AuthRepository = DefaultAuthRepository(networkAuthService: networkAuthService)
    lazy var postRepository: PostRepository = DefaultPostRepository(networkService: networkService)
    lazy var searchRepository: SearchRepository = DefaultSearchRepository(httpService: httpService)
    lazy var userRepository: UserRepository = DefaultUserRepository(networkAuthService: networkAuthService, httpService: httpService)
    lazy var resourceRepository: ResourceRepository = DefaultResourceRepository(networkService: networkService)
    lazy var commentEventRepository: CommentEventRepository = DefaultCommentEventRepository(networkService: networkService)

    lazy var homeUseCase = DefaultHomeUseCase(postRepository: postRepository,
                                              userRepository: userRepository,
                                              resourceRepository: resourceRepository,
                                              commentEventRepository: commentEventRepository)
    lazy var searchUseCase = DefaultSearchUseCase(searchRepository: searchRepository)
    lazy var authUseCase = DefaultAuthUseCase(authRepository: authRepository)
}
