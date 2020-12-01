//
//  ThemeCore.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 01.12.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol ThemeCoreProtocol {
    func getCurrentSavedTheme() -> Theme?
    func saveTheme(theme: Theme, completion: @escaping VoidClosure)
}

final class ThemeCore: ThemeCoreProtocol {
    
    private let selectedThemeKey = "selectedTheme"
    
    func getCurrentSavedTheme() -> Theme? {
        if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)
        }
        return nil
    }
    
    func saveTheme(theme: Theme, completion: @escaping VoidClosure) {
        DispatchQueue.global().async {
            UserDefaults.standard.setValue(theme.rawValue, forKey: self.selectedThemeKey)
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
