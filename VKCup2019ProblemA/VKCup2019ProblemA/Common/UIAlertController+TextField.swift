//
//  UIAlertController+TextField.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 22.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func makeTextField(title: String, message: String, completion: ((String) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: L10n.alertOkButton,
                                     style: .default) { [weak alertController] _ in
                                        guard let text = alertController?.textFields?.first?.text,
                                            !text.isEmpty else { return }
                                        completion?(text)
        }
        let cancelAction = UIAlertAction(title: L10n.cancelActionText,
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
