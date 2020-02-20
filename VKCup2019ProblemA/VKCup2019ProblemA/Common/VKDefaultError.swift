//
//  VKDefaultError.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 21.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

enum VKDefaultError {
    
    case `default`
    case unsupportedFormat
}

extension VKDefaultError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .default:
            return L10n.alertErrorDefaultMessage
        case .unsupportedFormat:
            return L10n.alertErrorUnsupportedFormatMessage
        }
    }
}
