//
//  AppDelegate.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        ThemeManager.setupNavigationBarAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let coreDataManager = CoreDataManager()
        let rootVC = ConversationsListViewController(coreDataManager: coreDataManager)
        let navController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}
