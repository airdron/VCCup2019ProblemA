//
//  UIViewController+SafeArea.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.

import UIKit

extension UIViewController {
    
    var topLayoutEdgeInset: CGFloat {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets.top
        } else {
            return self.topLayoutGuide.length
        }
    }
    
    var bottomLayoutEdgeInset: CGFloat {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets.bottom
        } else {
            return self.bottomLayoutGuide.length
        }
    }
}
