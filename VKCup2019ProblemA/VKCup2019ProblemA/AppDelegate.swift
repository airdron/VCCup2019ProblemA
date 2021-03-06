//
//  AppDelegate.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 15.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let dependencyService = DependencyService()
    private lazy var vkInitialization: VKInitializing = dependencyService.resolve()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        vkInitialization.vkInitialize()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationMainCoordinatorController(authModuleContainer: AuthModuleContainer(dependencyService: dependencyService),
                                                                         documentsModuleContainer: DocumentsModuleContainer(dependencyService: dependencyService),
                                                                         documentViewerContainer: DocumentViewerContainer(dependencyService: dependencyService),
                                                                         documentAlertFactory: DocumentAlertFactory(),
                                                                         authService: dependencyService.resolve())
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        VKSdk.processOpen(url, fromApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
        return true
    }
}
