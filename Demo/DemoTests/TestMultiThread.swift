//
//  TestMultiThread.swift
//  DemoTests
//
//  Created by huahuahu on 2019/1/19.
//  Copyright © 2019 huahuahu. All rights reserved.
//

@testable import Demo
@testable import HHHKit
import Quick
import Nimble

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
//            dispatch_sync called on queue already owned by current thread
//            DispatchQueue.main.sync {
//                // 在主线程，是主队列
//                XCTAssertEqual(DispatchQueue.isMain, true)
//                XCTAssertTrue(Thread.isMainThread)
//            }
        }

        DispatchQueue.main.async {
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(DispatchQueue.isMain, true)
            mainAsyncExp.fulfill()
        }

        wait(for: exps, timeout: 100)
    }

}

class MultiThread: QuickSpec {
    override func spec() {
        describe("dispatchOnce") {
            it(" 不同线程执行", closure: {
                let token = "testdf"
                var num = 0
                let count = Atomic<Int>.init(0)
                let group = DispatchGroup.init()
                DispatchQueue.concurrentPerform(iterations: 100, execute: { (index) in
                    group.enter()
                    DispatchQueue.global().async {
                        DispatchQueue.once(token: token) {
                            num += 1
                        }
                        count.mutate {
                            $0 += 1
                        }
                        group.leave()
                    }
                })
                group.wait()
                expect(count.value).to(equal(100))
                expect(num).to(equal(1))
            })
        }
    }
}
