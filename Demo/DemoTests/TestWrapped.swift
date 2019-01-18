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

    func testBindingBox() {
        let box = Box<Int>.init(4)
        var current = 3
        box.bind { (value) in
            current = value
        }

        XCTAssertEqual(current, 4, "初次数据绑定，会更新")
        (1...50).map { _ in
            Int.random(in: 0...3938393)
            }.forEach { (value) in
                box.value = value
                XCTAssertEqual(box.value, current)
                XCTAssertEqual(box.value, value)
        }
    }

    ///测试绑定多个对象
    func testMultiBind() {
        let box = Box<Int>.init(4)
        let observer1 = ObserverExample.init()
        let observer2 = ObserverExample.init()
        let observer3 = ObserverExample.init()

        box.bind { (value) in
            observer1.value = value
        }
        box.bind(target: observer2) { [unowned observer2 ] (value) in
            observer2.value = value
        }
        box.bind(target: observer3) { [unowned observer3 ] (value) in
            observer3.value = value
        }

        //初次绑定
        let observers = [observer1, observer2, observer3]
        observers.forEach { (observer) in
            XCTAssertEqual(observer.value, box.value)
        }

        // 每次更新都会通知到观察者
        (1...50).map { _ in
            Int.random(in: 0...3938393)
            }.forEach { (value) in
                box.value = value
                observers.forEach { (observer) in
                    XCTAssertEqual(observer.value, box.value)
                }
                XCTAssertEqual(box.value, value)
        }

        // 去掉 observer2 对box 的监听
        box.bind(target: observer2, block: nil)
        box.value = -9
        XCTAssertEqual(box.value, observer1.value)
        XCTAssertEqual(box.value, observer3.value)
        XCTAssertNotEqual(box.value, observer2.value)
    }
}

class ObserverExample {
    var value: Int = 0

}
