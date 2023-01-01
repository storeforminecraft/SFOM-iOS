//
//  CompactLPLinkView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/31.
//

import UIKit
import SwiftUI
import LinkPresentation
import Combine

struct  LPLinkViewRepresented: UIViewRepresentable {
    private let urlString: String
    static var cancellable = Set<AnyCancellable>()

    init(urlString: String) {
        self.urlString = urlString
    }

    func makeUIView(context: Context) -> LPLinkView {
        let lpLinkView = LPLinkView()

        //     .map { metadata -> LPLinkMetadata? in metadata }
        //     .replaceError(with: nil)
        //     .eraseToAnyPublisher()
        //     .sink(receiveValue: { metadata in
                // DispatchQueue.main.async {
                //     if let metadata = metadata {
                        // let lpLinkView = LPLinkView()
                        // lpLinkView.metadata = metadata
                        // lpLinkView.sizeToFit()
                        // uiView.addSubview(lpLinkView)
                    // }
                // }
            // })
            // .store(in: &LPLinkViewRepresented.cancellable)
        return lpLinkView
    }

    func updateUIView(_ uiView: LPLinkView, context: Context) {
        _ = LPMetadataProvider().startFetchingMetadataPublisher(for: urlString)
            .sink { e in
                print(e)
            } receiveValue: { d in
                print("O", d)
            }
    }
}

struct CompactLPView: View {
    private let urlString: String
    
    init(urlString: String){
        self.urlString = urlString
    }
    
    var body: some View {
        LPLinkViewRepresented(urlString: urlString )
    }
}
