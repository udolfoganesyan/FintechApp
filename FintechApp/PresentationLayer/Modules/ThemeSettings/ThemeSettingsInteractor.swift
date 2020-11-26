//
//  ThemeSettingsInteractor.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 13.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol ThemeSettingsInteractorProtocol {
    var currentTheme: Theme { get }
    func updateThemeWith(_ theme: Theme, completion: @escaping VoidClosure)
}

final class ThemeSettingsInteractor: ThemeSettingsInteractorProtocol {
    
    private let themeService: ThemeServiceProtocol
    
    var currentTheme: Theme {
        themeService.currentTheme
    }
    
    init(themeService: ThemeServiceProtocol) {
        self.themeService = themeService
    }
    
    func updateThemeWith(_ theme: Theme, completion: @escaping VoidClosure) {
        themeService.updateThemeWith(theme, completion: completion)
    }
}
