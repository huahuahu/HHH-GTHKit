//
//  CoreGraphUITests.swift
//  CoreGraphUITests
//
//  Created by huahuahu on 2019/1/13.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest

class CoreGraphUITests: XCTestCase {

    override func setUp() {

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testExample() {

        let app = XCUIApplication()
        app.tabBars.buttons["CoreGraph"].tap()

        let tablesQuery = app.tables
        tablesQuery.cells.staticTexts["demo1"].tap()

        let coregraphdemoButton = app.navigationBars["CoreGraphFunc.CoreGraphDemo"].buttons["CoreGraphDemo"]
        coregraphdemoButton.tap()
        tablesQuery.cells.staticTexts["demo2"].tap()
        coregraphdemoButton.tap()
    }
}
