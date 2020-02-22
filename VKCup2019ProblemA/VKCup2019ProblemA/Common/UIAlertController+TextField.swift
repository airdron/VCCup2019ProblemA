//
//  UIAlertController+TextField.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 22.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class RenameAlertController: UIAlertController {
    
    static func makeTextField(title: String, message: String, completion: ((String) -> Void)?) -> RenameAlertController {
        let alertController = RenameAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.addTarget(alertController, action: #selector(didChangeText), for: .editingChanged)
        }
        
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
        okAction.isEnabled = false
        return alertController
    }
    
    @objc
    func didChangeText() {
        let okAction = self.actions.first(where: { $0.style == .default })
        okAction?.isEnabled = textFields?.first?.text?.isEmpty == false
    }
}
