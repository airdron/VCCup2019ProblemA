//
//  DependencyService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

class DependencyService {
    
    private let vkAuthService = VKAuthService()
    private let documentsService = VKDocumentService()
    
    func resolve() -> VKInitializing {
        return vkAuthService
    }
    
    func resolve() -> AuthService {
        return vkAuthService
    }
    
    func resolve() -> DocumentDownloading {
        return documentsService
    }
    
    func resolve() -> DocumentsLoading {
        return documentsService
    }
    
    func resolve() -> DocumentDeleting {
        return documentsService
    }
}
