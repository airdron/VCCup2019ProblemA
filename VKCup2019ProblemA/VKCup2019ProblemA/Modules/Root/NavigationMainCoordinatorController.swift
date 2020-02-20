//
//  NavigationMainCoordinatorController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit
import SafariServices

class NavigationMainCoordinatorController: VKCupNavigationController {
     
    private let authService: AuthService
    private let authModuleContainer: AuthModuleContainer
    private let documentsModuleContainer: DocumentsModuleContainer
    private let documentViewerContainer: DocumentViewerContainer
    private let activityIndicator = UIActivityIndicatorView()
    
    init(authModuleContainer: AuthModuleContainer,
         documentsModuleContainer: DocumentsModuleContainer,
         documentViewerContainer: DocumentViewerContainer,
         authService: AuthService) {
        self.authModuleContainer = authModuleContainer
        self.documentsModuleContainer = documentsModuleContainer
        self.documentViewerContainer = documentViewerContainer
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = view.center
    }
    
    private func startAuthFlow() {
        activityIndicator.stopAnimating()
        
        let authViewController = authModuleContainer.make()
        
        authViewController.onCompletion = { [weak self] in
            self?.startDocumentsFlow()
        }
        
        setViewControllers([authViewController], animated: true)
    }
    
    private func startDocumentsFlow() {
        activityIndicator.stopAnimating()
        
        let viewController = documentsModuleContainer.make()
        
        viewController.onOpen = { [weak self] url, fileExtension, fileName in
            self?.openDocumentFlow(url: url,
                                   fileExtension: fileExtension,
                                   fileName: fileName)
        }
        
        setViewControllers([viewController], animated: true)
    }
    
    private func openDocumentFlow(url: URL,
                                  fileExtension: String,
                                  fileName: String) {
        let viewController = documentViewerContainer.make(url: url,
                                                          fileExtension: fileExtension,
                                                          fileName: fileName)
        present(viewController,
                animated: true,
                completion: nil)
    }
}
