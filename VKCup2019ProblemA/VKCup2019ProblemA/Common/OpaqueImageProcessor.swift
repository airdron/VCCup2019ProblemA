//
//  OpaqueImageProcessor.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 23.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Kingfisher

struct OpaqueImageProcessor: ImageProcessor {
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return getOpaqueImage(fromSourceImage: image, withScaleFactor: options.scaleFactor) ?? image

        case .data(let data):
            if let image = UIImage(data: data) {
                return getOpaqueImage(fromSourceImage: image, withScaleFactor: options.scaleFactor) ?? image
            }
            return nil
        }
    }
    
    var identifier: String = "com.airdron.opaque.image.processor"
    
    private func getOpaqueImage(fromSourceImage image: KFCrossPlatformImage, withScaleFactor scale: CGFloat) -> KFCrossPlatformImage? {
            let imageSize: CGSize = image.size
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let optimizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return optimizedImage ?? UIImage()
    }
    
}
