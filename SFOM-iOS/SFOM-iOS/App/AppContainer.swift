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
    let databaseService = FirebaseService.shared as DatabaseService
    
    lazy var authRepository: AuthRepository = DefaultAuthRepository(networkAuthService: networkAuthService,
                                                                    databaseService: databaseService,
                                                                    httpService: httpService)
    lazy var postRepository: PostRepository = DefaultPostRepository(networkService: networkService)
    lazy var searchRepository: SearchRepository = DefaultSearchRepository(httpService: httpService)
    lazy var userRepository: UserRepository = DefaultUserRepository(networkAuthService: networkAuthService,
                                                                    httpService: httpService)
    lazy var resourceRepository: ResourceRepository = DefaultResourceRepository(networkService: networkService)
    lazy var commentEventRepository: CommentEventRepository = DefaultCommentEventRepository(networkService: networkService)
    lazy var noticeRepository: NoticeRepository = DefaultNoticeRepository(networkService: networkService)
    
    lazy var homeUseCase = DefaultHomeUseCase(authRepository: authRepository,
                                              postRepository: postRepository,
                                              userRepository: userRepository,
                                              resourceRepository: resourceRepository,
                                              commentEventRepository: commentEventRepository)
    lazy var searchUseCase = DefaultSearchUseCase(searchRepository: searchRepository)
    lazy var authUseCase = DefaultAuthUseCase(authRepository: authRepository,
                                              userRepository: userRepository)
    lazy var menuUseCase = DefaultMenuUseCase(authRepository: authRepository,
                                              userRepository: userRepository)
    lazy var contentUseCase = DefaultContentUseCase(authRepository:authRepository,
                                                    resourceReposiotry: resourceRepository,
                                                    userRepository: userRepository)
    lazy var noticeUseCase = DefaultNoticeUseCase(noticeRepository: noticeRepository)
    lazy var postUseCase = DefaultPostUseCase(userRepository: userRepository,
                                              resourceRepository: resourceRepository)
    
    lazy var profileUseCaes = DefaultProfileUseCase(authRepository: authRepository,
                                                    userRepository: userRepository,
                                                    resourceRepository: resourceRepository)
}
