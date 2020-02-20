//
//  DocumentViewModel.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 17.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

struct DocumentViewModel {
    
    let placeholder: UIImage?
    let titleNumberOfLines: Int
    let title: NSAttributedString
    let subtitle: NSAttributedString
    let tags: NSAttributedString?
    let uuid: UUID = .init()
    let meta: Meta
    
    struct Meta {
        var src: URL
        var ext: String
        var fileName: String
    }
}
