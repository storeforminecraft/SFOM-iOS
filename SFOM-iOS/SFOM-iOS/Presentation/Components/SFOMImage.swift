//
//  SFOMImage.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import SwiftUI
import Combine
import Kingfisher

public struct SFOMImage: View {
    private var imageUrl: URL? = nil
    
    init(placeholder: Image, urlString: String?){
        if let urlString = urlString, let url = URL(string: urlString) {
            self.imageUrl = url
        }
    }

    public var body: some View {
        KFImage.url(imageUrl)
            .placeholder{
                Assets.Default.profileBackground.image
            }
            .fade(duration: 0.25)
            .resizable()
    }
}
