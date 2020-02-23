//
//  DocumentImageConstants.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 23.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit
import Kingfisher

class DocumentImageConstants {
    
    static let size = CGSize(width: 72, height: 72)
    static let cornerRadius: CGFloat = 6
    static let imageProcessor = ResizingImageProcessor(referenceSize: size,
                                                       mode: .aspectFill)
        .append(another: CroppingImageProcessor(size: size))
        .append(another: RoundCornerImageProcessor(cornerRadius: cornerRadius, backgroundColor: .white))
        .append(another: OpaqueImageProcessor())
    
    static let options: KingfisherOptionsInfo = [
        .processor(imageProcessor),
        .cacheSerializer(FormatIndicatedCacheSerializer.jpeg),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(0.2))
    ]
}
