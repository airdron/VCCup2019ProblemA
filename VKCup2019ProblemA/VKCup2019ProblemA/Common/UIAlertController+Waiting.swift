//
//  UIAlertController+Waiting.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

extension UIAlertController {

    static func makeWaiting() -> UIAlertController {
        let alertController = UIAlertController(title: "",
                                                message: L10n.alertWaitingTitle,
                                                preferredStyle: .alert)
        return alertController
    }
}
