//
//  TestURLEncodec.swift
//  DemoTests
//
//  Created by huahuahu on 2018/12/31.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest
@testable import Demo
@testable import HHHKit

class TestURLEncodec: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let str = "afdADGWaf/?_-~."
        XCTAssertEqual(str, str.urlQueryEscape(), "不用编码")
    }

}
