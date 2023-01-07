//
//  SFOMImageProcessor.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/01.
//

import UIKit
import Kingfisher

final class SFOMImageProcessor: ImageProcessor {
    var identifier: String = "SFOMImageProcessor"
    private let translate: (KFCrossPlatformImage)->(KFCrossPlatformImage?)
    
    init(_ translate: @escaping (KFCrossPlatformImage) -> KFCrossPlatformImage?) {
        self.translate = translate
    }
    
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case let .image(image):
            return DispatchQueue.main.sync {
                return translate(image)
            }
        case let .data(data):
            guard let image = UIImage(data: data) else { return nil }
            return DispatchQueue.main.sync {
                translate(image)
            }
        }
    }
}
