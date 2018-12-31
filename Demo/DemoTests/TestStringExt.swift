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

class TestStringExt: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnicode() {
        var string = "的"
        var encodedView = string.asciiViewOf(encodingType: .utf8)!
        XCTAssertEqual(encodedView, "E79A84".lowercased(), "utf8编码值")
        print(Data.Element.self)
    }

}
