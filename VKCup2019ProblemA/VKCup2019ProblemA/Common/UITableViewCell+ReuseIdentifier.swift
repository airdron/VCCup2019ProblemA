//
//  UITableViewCell+ReuseIdentifier.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 18.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
