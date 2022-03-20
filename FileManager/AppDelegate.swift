//
//  AppDelegate.swift
//  FileManager
//
//  Created by GiN Eugene on 17/3/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let docsViewModel = DocsViewModel()
    let loginViewModel = LoginViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let navigationController = UINavigationController(rootViewController: DocsViewController(docsViewModel: docsViewModel))
        let navigationController = UINavigationController(rootViewController: LogInViewController(loginViewModel: loginViewModel))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

