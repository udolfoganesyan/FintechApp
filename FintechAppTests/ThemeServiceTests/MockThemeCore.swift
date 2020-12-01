//
//  MockThemeCore.swift
//  FintechAppTests
//
//  Created by Rudolf Oganesyan on 01.12.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation
@testable import FintechApp

final class MockThemeCore: ThemeCoreProtocol {
    
    private var currentTheme: Theme?
    
    func getCurrentSavedTheme() -> Theme? {
        return currentTheme
    }
    
    func saveTheme(theme: Theme, completion: @escaping VoidClosure) {
        currentTheme = theme
        completion()
    }
}
