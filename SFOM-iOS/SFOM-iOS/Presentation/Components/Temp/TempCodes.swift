//
//  TempCodes.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/07.
//

import Foundation
import Kingfisher
import SwiftUI

final class SFOMImageViewModel: ViewModel {
    @Published var image: UIImage?
    
    func getImage(imageUrl: URL?, searchSkin: Bool? = nil) {
        guard let imageUrl = imageUrl else { return }
        let resource = ImageResource(downloadURL: imageUrl)
        
        let options: [KingfisherOptionsInfoItem] = searchSkin != nil ? [] : [.processor(AspectResizingImageProcessor(width: 300))]
        
        KingfisherManager.shared.retrieveImage(with: resource,
                                               options: options,
                                               progressBlock: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    withAnimation{
                        switch searchSkin {
                            // case true:  self.image = self.getUIImageToSearchImage(uiImage: value.image)
                            // case false: self.image = self.getUIImageToSkinImage(uiImage: value.image)
                        case nil: self.image = value.image
                        default: break
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

public func getUIImageToSearchImage(uiImage: UIImage) -> UIImage? {
    guard let cgImage = uiImage.cgImage else { return nil }
    let secondLayerEnable = cgImage.height >= 64
    
    let head = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 8, y: 8, width: 8, height: 8))!)
    let hat = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 40, y: 8, width: 8, height: 8))!)
    let torso = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 20, y: 20, width: 8, height: 6))!)
    let leftArm1 = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 44, y: 20, width: 4, height: 6))!)
    
    let size = CGSize(width: 150, height: 110)
    
    let centerWidth = 75.0
    let centerHeight = 110 - 42.0
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    leftArm1.draw(in: CGRect(x: centerWidth - 56, y: centerHeight, width: 28, height: 42))
    if secondLayerEnable {
        let rightArm2 = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 36, y: 52, width: 4, height: 6))!)
        rightArm2.draw(in: CGRect(x: centerWidth + 28, y: centerHeight, width: 28, height: 42))
    } else {
        let rightArm1 = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 44, y: 20, width: 4, height: 6))!)
        rightArm1.draw(in: CGRect(x: centerWidth + 28, y: centerHeight, width: 28, height: 42))
    }
    if secondLayerEnable {
        let leftArmAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 44, y: 36, width: 4, height: 6))!)
        let rightArmAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 52, y: 52, width: 4, height: 6))!)
        
        leftArmAcc.draw(in: CGRect(x: centerWidth - 56 - 3.5, y: centerHeight - 3.5, width: 28 + 7, height: 42 + 7))
        rightArmAcc.draw(in: CGRect(x: centerWidth + 28 - 3.5, y: centerHeight - 3.5, width: 28 + 7, height: 42 + 7))
    }
    torso.draw(in: CGRect(x: centerWidth - 28, y: centerHeight, width: 56, height: 42))
    if secondLayerEnable {
        let torsoAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 20, y: 36, width: 8, height: 6))!)
        torsoAcc.draw(in: CGRect(x: centerWidth - 28 - 3.5, y: centerHeight - 3.5, width: 56 + 7, height: 42 + 7))
    }
    head.draw(in: CGRect(x: centerWidth - 28, y: centerHeight - 56, width: 56, height: 56))
    hat.draw(in: CGRect(x: centerWidth - 28 - 3.5, y: centerHeight - 56 - 3.5, width: 56 + 7, height: 56 + 7))
    guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
    UIGraphicsEndImageContext()
    return newImage
}
