//
//  SFOMLPView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/18.
//

import UIKit
import SwiftUI
import LinkPresentation
import Combine

struct  LPLinkViewRepresented: UIViewRepresentable {
    var metadata: LPLinkMetadata
    
    func makeUIView(context: Context) -> LPLinkView {
        return LPLinkView(metadata: metadata)
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
        
    }
}

fileprivate final class CompactLPViewModel: ObservableObject {
    private let metadataProvider = LPMetadataProvider()
    private var cancellable = Set<AnyCancellable>()
    
    @Published var metadata: LPLinkMetadata?
    
    func fetch(urlString: String){
        metadataProvider.startFetchingMetadataPublisher(for: urlString)
            .map { metadata -> LPLinkMetadata? in metadata }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: \.metadata, on: self)
            .store(in: &cancellable)
    }
}

struct CompactLPView: View {
    @ObservedObject private var compactLPViewModel = CompactLPViewModel()
    
    init(urlString: String){
        compactLPViewModel.fetch(urlString: urlString) 
    }
    
    var body: some View {
        if let metadata = compactLPViewModel.metadata {
            LPLinkViewRepresented(metadata: metadata)
                .scaledToFit()
            ZStack {}
        } else {
            VStack { }
        }
    }
}

