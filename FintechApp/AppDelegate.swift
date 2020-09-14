//
//  AppDelegate.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Logger.log(message: "App starts as \"Not running\" and does its initial setup\": \(#function)")
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Logger.log(message: "App finishes initial setup and goes from \"Not running\" to \"Inactive\": \(#function)")
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        Logger.log(message: "App will move from \"Background\" to \"Inactive\": \(#function)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        Logger.log(message: "App moved from \"Inactive\" to \"Active\": \(#function)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        Logger.log(message: "App will go from \"Active\" to \"Inactive\": \(#function)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        Logger.log(message: "App moved from \"Inactive\" to \"Background\": \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        Logger.log(message: "App will move to \"Not running\": \(#function)")
    }
}
