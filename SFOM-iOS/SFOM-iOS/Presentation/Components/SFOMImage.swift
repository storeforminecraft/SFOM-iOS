//
//  SFOMImage.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import SwiftUI
import Combine

fileprivate final class SFOMImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    private var cancellable = Set<AnyCancellable>()
    
    func fetch(urlString: String){
        guard let url = URL(string: urlString) else { return }
        URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .map { (data, response) in  return data }
            .catch{ error -> AnyPublisher<Data?, Never> in
                Just<Data?>(nil).eraseToAnyPublisher()
            }
            .sink(receiveValue: self.receiveResponse(data:))
            .store(in: &cancellable)
    }
    
    private func receiveResponse(data: Data?) {
        guard let data =  data else { return }
        self.image = UIImage(data:data)
    }
}

struct SFOMImage: View {
    @ObservedObject private var sfomImageViewModel = SFOMImageViewModel()
    private var defaultImage: Image?
    
    init(urlString: String, defaultImage: Image? = nil, failureImage: Image? = nil){
        self.defaultImage = defaultImage
        self.sfomImageViewModel.fetch(urlString: urlString)
    }
    
    var body: some View {
        if let uiImage = sfomImageViewModel.image {
            ZStack{
                Image(uiImage: uiImage)
                    .resizable()
            }
        } else if let defaultImage = defaultImage {
            ZStack{
                defaultImage
                    .resizable()
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(3)
                    .tint(.accentColor)
            }
        } else {
            defaultImage
        }
    }
}

struct SFOMImage_Previews: PreviewProvider {
    static var previews: some View {
        SFOMImage(urlString: "ht",
                  defaultImage: Assets.Default.profileBackground.image)
    }
}
