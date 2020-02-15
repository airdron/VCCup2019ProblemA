//
//  NavigationMainCoordinatorController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class NavigationMainCoordinatorController: VKCupNavigationController {
     
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authService.authCheck { [weak self] result in
            switch result {
            case .success(let isAuthorized):
                if isAuthorized {
                    self?.startDocumentsFlow()
                } else {
                    self?.startAuthFlow()
                }
            case .failure(let error):
                self?.showAlert(error: error)
            }
        }
    }
    
    private func startAuthFlow() {
        let authViewController = AuthViewController(authService: authService)
        
        authViewController.onCompletion = { [weak self] in
            self?.startDocumentsFlow()
        }
        
        setViewControllers([authViewController], animated: true)
    }
    
    private func startDocumentsFlow() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        setViewControllers([viewController], animated: true)
    }
}