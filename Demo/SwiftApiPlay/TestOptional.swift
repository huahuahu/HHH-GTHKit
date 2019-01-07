//
//  TestOptional.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/7.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import HHHKit

class TestOptional: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExtendeOptionalString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var str: String?
        XCTAssertTrue(str.isNil)
        str = "daf"
        XCTAssertTrue(str.isNotNil)
    }

    func testExtendedOptionalBool() {
        var boo: Bool?
        XCTAssertTrue(boo.orTrue)
        XCTAssertFalse(boo.orFalse)
        boo = true
        XCTAssertTrue(boo.orTrue)
        XCTAssertTrue(boo.orFalse)
        boo = false
        XCTAssertFalse(boo.orFalse)
        XCTAssertFalse(boo.orTrue)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension Optional where Wrapped == String {
    var isNil: Bool {
        if let str = self {
            print("self is \(str)")
            return false
        } else {
            return true
        }
    }

    var isNotNil: Bool {
        return !isNil
    }
}
