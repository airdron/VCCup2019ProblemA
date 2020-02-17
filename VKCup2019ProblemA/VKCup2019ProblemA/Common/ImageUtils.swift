//
//  ImageUtils.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 18.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

func optimizedImage(from image: UIImage?) -> UIImage {
    let image = image ?? UIImage()
    let imageSize: CGSize = image.size
    UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
    image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
    let optimizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return optimizedImage ?? UIImage()
}
