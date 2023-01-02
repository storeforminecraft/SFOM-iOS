//
//  Kingfisher+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/01.
//

import Foundation
import Kingfisher

// extension Source {
//     public func cacheKey(_ key: String) -> Source {
//         switch self {
//         case .network(let resource):
//             return .network(ImageResource(downloadURL: resource.downloadURL, cacheKey: key))
//         case .provider(let provider):
//            
//             return .provider(LocalFileImageDataProvider(fileURL: provider.contentURL, cacheKey: key, loadingQueue: provider))
//         }
//     }
// }

extension KFImageProtocol {
    public init(_ url: URL?, overrideCacheKey: String? = nil) {
        self.init(source: url?.convertToSource(overrideCacheKey: overrideCacheKey))
    }
    
}
