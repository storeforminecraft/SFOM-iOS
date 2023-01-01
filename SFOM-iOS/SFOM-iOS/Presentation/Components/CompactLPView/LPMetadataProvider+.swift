//
//  LPMetadataProvider+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/31.
//

import LinkPresentation
import Combine

extension LPMetadataProvider {
    func startFetchingMetadataPublisher(for urlString: String) -> AnyPublisher<LPLinkMetadata, Error>{
        Future<LPLinkMetadata,Error> { promise in
            guard let url = URL(string: urlString) else {
                promise(.failure(CompactLPError.urlError))
                return
            }
            self.startFetchingMetadata(for: url) { metadata, error in
                do {
                    if let error = error { throw error }
                    guard let metadata = metadata else { throw CompactLPError.noDataError }
                    promise(.success(metadata))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
