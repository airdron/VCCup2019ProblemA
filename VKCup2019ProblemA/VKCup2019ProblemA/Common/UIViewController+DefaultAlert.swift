//
//  UIViewController+DefaultAlert.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(error: Error, animated: Bool = true, completion: Action? = nil) {
        let alertController = UIAlertController.make(with: error)
        present(alertController, animated: animated, completion: completion)
    }
}
