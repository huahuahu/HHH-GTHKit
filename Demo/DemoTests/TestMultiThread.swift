//
//  TestMultiThread.swift
//  DemoTests
//
//  Created by huahuahu on 2019/1/19.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import HHHKit

class TestMultiThread: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsMain() {
        // 在主线程，是主队列
        XCTAssertEqual(DispatchQueue.isMain, true)
        XCTAssertTrue(Thread.isMainThread)
        let globalAsyncExp = XCTestExpectation.init(description: "globalQueue exec")
        let mainAsyncExp = XCTestExpectation.init(description: "globalQueue exec")
        let exps = [globalAsyncExp, mainAsyncExp]
        DispatchQueue.global().async {
            //不在主线程，不是主队列
            XCTAssertFalse(Thread.isMainThread)
            XCTAssertEqual(DispatchQueue.isMain, false)
            print("async called")
            globalAsyncExp.fulfill()
        }
        DispatchQueue.global().sync {
            //在主线程，不是主队列
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(DispatchQueue.isMain, false)
        }

        DispatchQueue.main.async {
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(DispatchQueue.isMain, true)
            mainAsyncExp.fulfill()
        }

        wait(for: exps, timeout: 100)
    }

}
