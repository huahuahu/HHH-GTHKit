//
//  TestNumberHex.swift
//  DemoTests
//
//  Created by huahuahu on 2018/12/31.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest
@testable import Demo
@testable import HHHKit

class TestNumberHex: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUInt8Hex() {
        var int: UInt8 = 0
        XCTAssertEqual(int.bigEndianHex, "00", "全是零")
        XCTAssertEqual(int.bigEndianHex, int.littleEndianHex, "大小端一样")

        int = 9
        XCTAssertEqual(int.bigEndianHex, "09", "前面补0")
        XCTAssertEqual(int.bigEndianHex, int.littleEndianHex, "大小端一样")

        int = 0x12
        XCTAssertEqual(int.bigEndianHex, "12", "正常表示")
        XCTAssertEqual(int.bigEndianHex, int.littleEndianHex, "大小端一样")
    }

    func testUInt16Hex() {
        var int: UInt16 = 0
        XCTAssertEqual(int.bigEndianHex, "0000", "全是零")
        XCTAssertEqual(int.littleEndianHex, "0000", "全是零")

        int = 9
        XCTAssertEqual(int.bigEndianHex, "0009", "前面补0")
        XCTAssertEqual(int.littleEndianHex, "0900", "前面补0")

        int = 0x12
        XCTAssertEqual(int.bigEndianHex, "0012", "前面补0")
        XCTAssertEqual(int.littleEndianHex, "1200", "高位在后")

        int = 0xa790
        XCTAssertEqual(int.bigEndianHex, "a790", "高位在前")
        XCTAssertEqual(int.littleEndianHex, "90a7", "高位在后")
    }

    func testUInt32Hex() {
        var int: UInt32 = 0
        XCTAssertEqual(int.bigEndianHex, "00000000", "全是零")
        XCTAssertEqual(int.littleEndianHex, "00000000", "全是零")

        int = 9
        XCTAssertEqual(int.bigEndianHex, "00000009", "前面补0")
        XCTAssertEqual(int.littleEndianHex, "09000000", "补0")

        int = 0x12
        XCTAssertEqual(int.bigEndianHex, "00000012", "前面补0")
        XCTAssertEqual(int.littleEndianHex, "12000000", "高位在后")

        int = 0xa790
        XCTAssertEqual(int.bigEndianHex, "0000a790", "高位在前")
        XCTAssertEqual(int.littleEndianHex, "90a70000", "高位在后")

        int = 0x1234a790
        XCTAssertEqual(int.bigEndianHex, "1234a790", "高位在前")
        XCTAssertEqual(int.littleEndianHex, "90a73412", "高位在后")
    }
}
