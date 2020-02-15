//
//  UIAlertController+Error.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func make(with error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: L10n.alertErrorTitle,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: L10n.alertOkButton, style: .cancel) { [weak alertController] _ in
            alertController?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(dismissAction)
        return alertController
    }
}
