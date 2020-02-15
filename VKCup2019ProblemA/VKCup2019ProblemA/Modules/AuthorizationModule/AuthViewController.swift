//
//  AuthViewController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 15.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

class AuthViewController: UIViewController {
    
    private let authService: AuthService
    var onCompletion: Action?
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.loginButton, for: UIControl.State())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(loginTouch), for: .touchUpInside)
        return button
    }()
    
    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VKSdk.instance()?.uiDelegate = self
        view.backgroundColor = UIColor.white
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc
    private func loginTouch() {
        authService.login { [weak self] result in
            switch result {
            case .success:
                self?.onCompletion?()
            case .failure(let error):
                self?.showAlert(error: error)
            }
        }
    }
}

extension AuthViewController: VKSdkUIDelegate {
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        showAlert(error: captchaError.httpError)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: false, completion: nil)
    }
}
