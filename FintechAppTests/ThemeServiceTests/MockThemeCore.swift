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
    var fetchingCounter = 0
    var savingCounter = 0
    
    func getCurrentSavedTheme() -> Theme? {
        fetchingCounter += 1
        return currentTheme
    }
    
    func saveTheme(theme: Theme, completion: @escaping VoidClosure) {
        savingCounter += 1
        currentTheme = theme
        completion()
    }
}
