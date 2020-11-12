//
//  ThemeService.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 04.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

protocol ThemeServiceProtocol {
    var currentTheme: Theme { get }
    func updateThemeWith(_ theme: Theme, completion: @escaping () -> Void)
    func setupNavigationBarAppearance()
}

final class ThemeService: ThemeServiceProtocol {
    
    private let selectedThemeKey = "selectedTheme"
    
    var currentTheme: Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .classic
        }
    }
    
    func updateThemeWith(_ theme: Theme, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            UserDefaults.standard.setValue(theme.rawValue, forKey: self.selectedThemeKey)
            
            DispatchQueue.main.async {
                self.setupNavigationBarAppearance()
                completion()
            }
        }
    }
    
    func setupNavigationBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.barTintColor = currentTheme.backgroundColor
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: currentTheme.primaryTextColor]
    }
}
