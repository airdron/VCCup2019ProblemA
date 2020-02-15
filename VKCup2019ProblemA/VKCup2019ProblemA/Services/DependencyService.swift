//
//  DependencyService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

class DependencyService {
    
    private let vkAuthService = VKAuthService()
    
    func resolve() -> VKInitializing {
        return vkAuthService
    }
    
    func resolve() -> AuthService {
        return vkAuthService
    }
}
