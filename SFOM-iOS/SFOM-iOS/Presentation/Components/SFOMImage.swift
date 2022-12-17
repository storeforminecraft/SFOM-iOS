//
//  SFOMImage.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import SwiftUI
import Combine

// TODO: - 이미지 캐싱 및 view model 처리 작업
final class SFOMImageViewModel: ObservableObject {
    @Published private(set) var image: Image? = nil
    @Published private(set) var progressing: Bool = false
    
    private var failureImage: Image? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    func setDefaultImage(image: Image?) {
        self.image = image
    }
    
    func setFailureImage(image: Image?) {
        self.failureImage = image
    }
    
    func fetch(urlString: String){
        self.image = nil
        self.progressing = true
        guard let url = URL(string: urlString) else { return }
        URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .map { (data, response) in  return data }
            .catch{ error -> AnyPublisher<Data?, Never> in
                Just<Data?>(nil).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.receiveResponse(data:))
            .store(in: &cancellable)
    }
    
    private func receiveResponse(data: Data?) {
        self.progressing = false
        guard let data =  data,  let uiImage = UIImage(data:data) else {
            if let failureImage = self.failureImage {
                self.image = failureImage
            }
            return
        }
        self.image = Image(uiImage: uiImage)
    }
}

public struct SFOMImage: View {
    @ObservedObject private var sfomImageViewModel = SFOMImageViewModel()
    
    init(defaultImage: Image){
        sfomImageViewModel.setDefaultImage(image: defaultImage)
    }
    
    init(urlString: String, defaultImage: Image? = nil, failureImage: Image? = nil){
        sfomImageViewModel.setDefaultImage(image: defaultImage)
        sfomImageViewModel.setFailureImage(image: failureImage)
        self.sfomImageViewModel.fetch(urlString: urlString)
    }
    
    public var body: some View {
        ZStack (alignment: .center) {
            if let sfomImage = sfomImageViewModel.image {
                sfomImage
                    .resizable()
            }
            if sfomImageViewModel.progressing {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(3)
                    .tint(.accentColor)
            }
        }
    }
}
