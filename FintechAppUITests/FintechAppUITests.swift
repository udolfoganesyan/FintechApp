//
//  FintechAppUITests.swift
//  FintechAppUITests
//
//  Created by Rudolf Oganesyan on 01.12.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import XCTest

class FintechAppUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UItesting"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testProfileInputFieldsCount() {
        //given
        let userInitials = "RO"
        
        //when
        let app = XCUIApplication()
        app.navigationBars["Channels"].staticTexts[userInitials].tap()
        app.buttons["Edit"].tap()
        let numberOfTextViews = app.descendants(matching: .textView).count
        let numberOfTextFields = app.descendants(matching: .textField).count
        let totalNumberOfInputFields = numberOfTextViews + numberOfTextFields
        
        //then
        XCTAssertEqual(totalNumberOfInputFields, 2)
    }
}
