//
//  StringFormat.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2018/12/31.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest

class StringFormat: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIntFormat() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var number = 1234
        var str = String.init(format: "%09x", number)
        XCTAssertEqual(str, "0000004d2", "最少9位，不足0补齐，16进制表示")

        str = String.init(format: "%09d", number)
        XCTAssertEqual(str, "000001234", "最少9位，不足0补齐，10进制表示")

        number = 0x1234
        str = String.init(format: "%03x", number)
        XCTAssertEqual(str, "1234", "前面不用补0了")
    }

}
