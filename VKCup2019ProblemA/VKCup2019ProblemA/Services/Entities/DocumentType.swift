//
//  DocumentType.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 18.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

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
