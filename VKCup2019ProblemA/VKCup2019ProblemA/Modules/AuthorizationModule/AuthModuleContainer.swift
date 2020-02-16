//
//  AuthModuleContainer.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class AuthModuleContainer {
    
    private let dependencyService: DependencyService
    
    init(dependencyService: DependencyService) {
        self.dependencyService = dependencyService
    }
    
    func make() -> AuthViewController {
        let viewController = AuthViewController(authService: dependencyService.resolve())
        return viewController
    }
}
