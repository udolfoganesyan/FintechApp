//
//  ThemeServiceTests.swift
//  FintechAppTests
//
//  Created by Rudolf Oganesyan on 01.12.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import XCTest
@testable import FintechApp

final class ThemeServiceTests: XCTestCase {

    private var sut: ThemeServiceProtocol?
    private var themeCore: ThemeCoreProtocol!
    
    override func setUp() {
        super.setUp()
        themeCore = MockThemeCore()
        sut = ThemeService(themeCore: themeCore)
    }
    
    override func tearDown() {
        themeCore = nil
        sut = nil
        super.tearDown()
    }
    
    func testDefaultThemeIsClassic() {
        XCTAssertEqual(sut?.currentTheme, Theme.classic)
    }
    
    func testGettingSavedTheme() {
        //given
        let themeToSave = Theme.night
        
        //when
        sut?.updateThemeWith(themeToSave, completion: { })
        
        //then
        XCTAssertEqual(sut?.currentTheme, themeToSave)
    }
    
    func testServiceUpdatesNavigationBar() {
        //given
        let themeToSave = Theme.day
        
        //when
        sut?.updateThemeWith(themeToSave, completion: { })
        
        //then
        XCTAssertEqual(UINavigationBar.appearance().barTintColor, sut?.currentTheme.backgroundColor)
    }
}
