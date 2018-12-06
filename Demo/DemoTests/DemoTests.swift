//
//  DemoTests.swift
//  DemoTests
//
//  Created by huahuahu on 2018/12/7.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest
@testable import Demo
@testable import HHHKit

class DemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(isEven(2))
        XCTAssertTrue(isEven(22))
        XCTAssertTrue(isEven(0))
        XCTAssertTrue(isEven(-2))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
