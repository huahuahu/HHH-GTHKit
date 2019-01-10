//
//  TestWrapped.swift
//  DemoTests
//
//  Created by huahuahu on 2019/1/10.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import HHHKit

class TestWrapped: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMutateAtomicOk() {
        let wrapped = Atomic<Int>.init(5)
        wrapped.value += 1
        XCTAssertEqual(wrapped.value, 6, "先通过get方法，再通过set方法，增加了1")
        wrapped.mutate { $0 += 1}
        XCTAssertEqual(wrapped.value, 7, "通过闭包，增加了1")
    }

    func testMultiThreadAtomic() {
        let wrapped = Atomic<Int>.init(0)
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 100 // 模拟多线程
        /// 直接set方法，不靠谱
        /// 可能 线程1读，线程2读，线程1改变，线程2改变；线程1的改变就丢失了
        queue.isSuspended = true
        let changeCount = 1000
        (0..<changeCount).forEach { _ in
            queue.addOperation {
                wrapped.value += 1
            }
        }
        queue.isSuspended = false
        queue.waitUntilAllOperationsAreFinished()
        XCTAssertNotEqual(changeCount, wrapped.value)
        print("expected is \(changeCount), result is \(wrapped.value)")

        /// 使用mutate 靠谱
        wrapped.value = 0
        queue.isSuspended = true
        (0..<changeCount).forEach { _ in
            queue.addOperation {
                wrapped.mutate { $0 += 1}
            }
        }
        queue.isSuspended = false
        queue.waitUntilAllOperationsAreFinished()
        XCTAssertEqual(changeCount, wrapped.value)
        print("expected is \(changeCount), result is \(wrapped.value)")
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
