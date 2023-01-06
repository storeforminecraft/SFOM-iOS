//
//  DefaultFileRepository.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/01.
//

import Foundation
import Combine

final class DefaultFileRepository {
    private let httpService: HTTPService
    private let downloadListStorage: DownloadListStorage
    
    init(httpService: HTTPService, downloadListStorage: DownloadListStorage) {
        self.httpService = httpService
        self.downloadListStorage = downloadListStorage
    }
}

extension DefaultFileRepository {
    func download(urlString: String) {

    }
}
