//
//  ThemeManager.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 04.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

enum ThemeManager {
    
    static private let selectedThemeKey = "selectedTheme"
    
    static var currentTheme: Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .classic
        }
    }
    
    static func updateThemeWith(_ theme: Theme, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
            
            setupNavigationBarAppearance()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    static func setupNavigationBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.barTintColor = ThemeManager.currentTheme.backgroundColor
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.primaryTextColor]
    }
}
