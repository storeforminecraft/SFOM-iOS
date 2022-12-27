//
//  SFOMImage.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/04.
//

import UIKit
import SwiftUI
import Combine
import Kingfisher

struct SFOMSkinImage: View {
    private let imageUrl: URL?
    private let search: Bool
    
    init(placeholder: Image, urlString: String?, search: Bool = false){
        if let urlString = urlString, let url = URL(string: urlString) {
            self.imageUrl = url
        } else {
            self.imageUrl = nil
        }
        self.search = search
    }
    
    var body: some View {
        KFImage(imageUrl)
            // .setProcessor(SFOMImageProcessor.default)
            .placeholder{
                Assets.Default.profileBackground.image
            }
            .fade(duration: 0.25)
            .resizable()
    }
}

public struct SFOMImageProcessor: ImageProcessor {
    public static let `default` = SFOMImageProcessor()
    public let identifier = "SFOMImageProcessor"
    public init() {}
    
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return self.getUIImageToSkinImage(uiImage: image.images?.first)
        case .data(let data):
            return self.getUIImageToSkinImage(uiImage: UIImage(data: data))
        }
    }
    
    public func getUIImageToSkinImage(uiImage: UIImage?) -> UIImage? {
        guard let cgImage = uiImage?.cgImage else {
            return nil
        }
        let secondLayerEnable = cgImage.height >= 64
        
        let head = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 8, y: 8, width: 8, height: 8))!)
        let hat = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 40, y: 8, width: 8, height: 8))!)
        let torso = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 20, y: 20, width: 8, height: 12))!)
        let leftArm1 = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 44, y: 20, width: 4, height: 12))!)
        let leftLeg = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 20, y: 52, width: 4, height: 12))!)
        let rightLeg = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 4, y: 20, width: 4, height: 12))!)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let safeAreaTop = window?.safeAreaInsets.top ?? 0
        let size = CGSize(width: 120, height: 240)
        
        let centerWidth = size.width / 2
        let centerHeight = size.height / 2
        
        UIGraphicsBeginImageContext(size)
        leftArm1.draw(in: CGRect(x: centerWidth - 56, y: centerHeight - 56, width: 28, height: 84))
        
        if secondLayerEnable {
            let rightArm2 = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 36, y: 52, width: 4, height: 12))!)
            rightArm2.draw(in: CGRect(x: centerWidth + 28, y: centerHeight - 56, width: 28, height: 84))
        } else {
            let rightArm1 = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 44, y: 20, width: 4, height: 12))!)
            rightArm1.draw(in: CGRect(x: centerWidth + 28, y: centerHeight - 56, width: 28, height: 84))
        }
        
        leftLeg.draw(in: CGRect(x: centerWidth, y: centerHeight + 28, width: 28, height: 84))
        rightLeg.draw(in: CGRect(x: centerWidth - 28, y: centerHeight + 28, width: 28, height: 84))
        
        if secondLayerEnable {
            let leftArmAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 44, y: 36, width: 4, height: 12))!)
            let rightArmAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 52, y: 52, width: 4, height: 12))!)
            let leftLegAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 4, y: 52, width: 4, height: 12))!)
            let rightLegAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 4, y: 36, width: 4, height: 12))!)
            
            leftArmAcc.draw(in: CGRect(x: centerWidth - 56 - 3.5, y: centerHeight - 56 - 3.5, width: 28 + 7, height: 84 + 7))
            rightArmAcc.draw(in: CGRect(x: centerWidth + 28 - 3.5, y: centerHeight - 56 - 3.5, width: 28 + 7, height: 84 + 7))
            leftLegAcc.draw(in: CGRect(x: centerWidth - 3.5, y: centerHeight + 28 - 3.5, width: 28 + 7, height: 84 + 7))
            rightLegAcc.draw(in: CGRect(x: centerWidth - 28 - 3.5, y: centerHeight + 28 - 3.5, width: 28 + 7, height: 84 + 7))
        }
        
        torso.draw(in: CGRect(x: centerWidth - 28, y: centerHeight - 56, width: 56, height: 84))
        
        if secondLayerEnable {
            let torsoAcc = UIImage(cgImage: cgImage.cropping(to: CGRect(x: 20, y: 36, width: 8, height: 12))!)
            torsoAcc.draw(in: CGRect(x: centerWidth - 28 - 3.5, y: centerHeight - 56 - 3.5, width: 56 + 7, height: 84 + 7))
        }
        
        head.draw(in: CGRect(x: centerWidth - 28, y: centerHeight - 112, width: 56, height: 56))
        hat.draw(in: CGRect(x: centerWidth - 28 - 3.5, y: centerHeight - 112 - 3.5, width: 56 + 7, height: 56 + 7))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let newSize = CGSize(width: UIScreen.main.bounds.width, height: 250 + safeAreaTop)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        newImage.draw(in: CGRect(x: newSize.width / 2 - 50, y: (newSize.height - safeAreaTop) / 2 + safeAreaTop - 100, width: 100, height: 200))
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public func getUIImageToSearchImage(uiImage: UIImage?) -> AnyPublisher<Image?, Never> {
        return Future<Image?, Never> { promiss in
            guard let cgImage = uiImage?.cgImage else {
                promiss(.success(nil))
                return
            }
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
            
            guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                promiss(.success(nil))
                return
            }
            UIGraphicsEndImageContext()
            promiss(.success(Image(uiImage: newImage)))
        }.eraseToAnyPublisher()
    }
}
