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
    func updateThemeWith(_ theme: Theme, completion: @escaping VoidClosure)
    func setupNavigationBarAppearance()
}

final class ThemeService: ThemeServiceProtocol {
    
    private let themeCore: ThemeCoreProtocol
    
    var currentTheme: Theme {
        return themeCore.getCurrentSavedTheme() ?? .classic
    }
    
    init(themeCore: ThemeCoreProtocol) {
        self.themeCore = themeCore
    }
    
    func updateThemeWith(_ theme: Theme, completion: @escaping VoidClosure) {
        themeCore.saveTheme(theme: theme) {
            self.setupNavigationBarAppearance()
            completion()
        }
    }
    
    func setupNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.barTintColor = currentTheme.backgroundColor
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: currentTheme.primaryTextColor]
    }
}
