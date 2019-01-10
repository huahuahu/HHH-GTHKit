//
//  TestDataAndTime.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/10.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest

class TestDataAndTime: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDayLightSaving() {
//        https://www.objc.io/blog/2018/12/04/unexpected-results-from-a-date-formatter/
        let formatter: DateFormatter = {
            let format = DateFormatter.init()
            format.locale = Locale.init(identifier: "en_US_POSIX")
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return format
        }()

        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        XCTAssertNotNil(formatter.date(from: "2017-03-26T00:53:31"))
        XCTAssertNotNil(formatter.date(from: "2017-03-26T02:53:31"))

        formatter.timeZone = TimeZone.init(identifier: "Europe/Berlin")
        XCTAssertNotNil(formatter.date(from: "2017-03-26T00:53:31"))
        // 这是一个不存在的时间，夏令时原因
        XCTAssertNil(formatter.date(from: "2017-03-26T02:53:31"))

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
