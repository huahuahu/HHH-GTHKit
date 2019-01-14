//
//  TestLocks.swift
//  DemoTests
//
//  Created by huahuahu on 2019/1/14.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import HHHKit

class TestLocks: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSyncBlock() {
        var value = 0
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 100 // 模拟多线程
        /// 直接set方法，不靠谱
        /// 可能 线程1读，线程2读，线程1改变，线程2改变；线程1的改变就丢失了
        queue.isSuspended = true
        let changeCount = 10000
        (0..<changeCount).forEach { _ in
            queue.addOperation {
                value += 1
            }
        }
        queue.isSuspended = false
        queue.waitUntilAllOperationsAreFinished()
        XCTAssertNotEqual(changeCount, value)
        print("expected is \(changeCount), result is \(value)")

        value = 0
        queue.isSuspended = true
        (0..<changeCount).forEach { _ in
            queue.addOperation {
                //被加锁了
                synchronized(self) {
                    value += 1
                }
            }
        }
        queue.isSuspended = false
        queue.waitUntilAllOperationsAreFinished()
        XCTAssertEqual(changeCount, value)
        print("expected is \(changeCount), result is \(value)")

    }

}
