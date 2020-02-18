//
//  DocumentType.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 18.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

enum DocumentType: Int, Codable {
    case text = 1
    case archives
    case gif
    case images
    case audio
    case video
    case ebooks
    case unknown
}

extension DocumentType {
    
    var placeholderImage: UIImage? {
        switch self {
        case .text:
            return UIImage(named: "PlaceholderText")
        case .archives:
            return UIImage(named: "PlaceholderZip")
        case .gif:
            return UIImage(named: "PlaceholderOther")
        case .images:
            return UIImage(named: "PlaceholderOther")
        case .audio:
            return UIImage(named: "PlaceholderMusic")
        case .video:
            return UIImage(named: "PlaceholderVideo")
        case .ebooks:
            return UIImage(named: "PlaceholderBook")
        case .unknown:
            return UIImage(named: "PlaceholderOther")
        }
    }
}
