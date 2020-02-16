//
//  VKAuthService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 15.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKAuthService: NSObject, AuthService, VKInitializing {
    
    private let appId = "7322295"
    private let apiVersion = "5.103"
    private let scope = [VK_PER_DOCS]
    
    private var authCompletion: ((Result<Void, Error>) -> Void)?
    
    func vkInitialize() {
        if !VKSdk.initialized(), let instance = VKSdk.initialize(withAppId: appId, apiVersion: apiVersion) {
            instance.register(self)
        }
    }
    
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        authCompletion = completion
        VKSdk.authorize(scope)
    }
    
    func authCheck(completion: @escaping (Result<Bool, Error>) -> Void) {
        VKSdk.wakeUpSession(scope) { (state, error) in
            if state == .authorized {
                completion(.success(true))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(false))
            }
        }
    }
}

extension VKAuthService: VKSdkDelegate {
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.state == .authorized {
            authCompletion?(.success(()))
        } else if let error = result.error {
            authCompletion?(.failure(error))
        }
    }
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        if result.state == .authorized {
            authCompletion?(.success(()))
        } else if let error = result.error {
            authCompletion?(.failure(error))
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        authCompletion?(.failure(NSError()))
    }
    
    func vkSdkAccessTokenUpdated(_ newToken: VKAccessToken!, oldToken: VKAccessToken!) {}
}
