//
//  MemoryLayout.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/5.
//  Copyright © 2019 huahuahu. All rights reserved.
//
//https://juejin.im/post/5c2cc325518825480635dd39

import XCTest
//swiftlint:disable line_length

class MemoryLayoutTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUnsafePointer() {
        // 必须用var，不能用let
        var testObj = Obj()
        let unsafePointer = withUnsafePointer(to: &testObj) { (pointer) -> UnsafePointer<Obj> in
            return pointer
        }

        XCTAssertEqual(testObj.str, unsafePointer.pointee.str)
        testObj.str = "new str"
        XCTAssertEqual(testObj.str, unsafePointer.pointee.str)

//        pointee' is a get-only property
//        unsafePointer.pointee = Obj()

        let unsafeMutablePointer = withUnsafeMutablePointer(to: &testObj, {$0})
        XCTAssertEqual(testObj.str, unsafeMutablePointer.pointee.str)
        testObj.str = "new str2"
        XCTAssertEqual(testObj.str, unsafeMutablePointer.pointee.str)

        let newObj = Obj()

        //这句话，会使得原来的testObj 被 deinit
        //运行完毕以后，testObj，会发生变化
        unsafeMutablePointer.pointee = newObj
        XCTAssertEqual(testObj.str, unsafeMutablePointer.pointee.str)
    }

    func testRawPointer() {
        var rawObj = Obj()
        // obj -> unsafeRawPointer
        let pointerRaw = withUnsafeBytes(of: &rawObj, {$0})

        // unsafeRawPointer -> unsafePointer
        guard let pointer = pointerRaw.bindMemory(to: Obj.self).baseAddress else { fatalError("这段代码理论上不能执行到这") }

        // unsafePointer -> obj
        let objFromPointer = pointer.pointee
        XCTAssertEqual(rawObj.str, objFromPointer.str, "同一个内存地址")
        rawObj.str = "new str"
        XCTAssertEqual(rawObj.str, objFromPointer.str, "同一个内存地址，一起改变")
    }

    func testMemoryLayout() {
//        The contiguous memory footprint of T, in bytes
        XCTAssertEqual(MemoryLayout<Int>.size, 8, "64位Int，实际占用8个字节")
//        The number of bytes from the start of one instance of T to the start of the next when stored in contiguous memory or in an Array<T>
        //连续存储时，两个实例首部的间距
        XCTAssertEqual(MemoryLayout<Int>.stride, 8, "连续存储时，每两个Int，内存地址差距是8")
//      内存对齐方式时8字节
        XCTAssertEqual(MemoryLayout<Int>.alignment, 8, "64位，8个字节")

        XCTAssertEqual(MemoryLayout<Bool>.size, 1, "Bool占用1个字节")
        XCTAssertEqual(MemoryLayout<Bool>.stride, 1, "连续存储时，每两个Bool，内存地址差距是1")
        XCTAssertEqual(MemoryLayout<Bool>.alignment, 1, "Bool，对齐方式是1")

        XCTAssertEqual(MemoryLayout<Test>.size, 17, "实际占用 17字节")
        XCTAssertEqual(MemoryLayout<Test>.alignment, 8, "8位对齐")
        XCTAssertEqual(MemoryLayout<Test>.stride, 24, "")

        XCTAssertEqual(MemoryLayout<TestBoolCon>.size, 16, "实际占用 17字节")
        XCTAssertEqual(MemoryLayout<TestBoolCon>.alignment, 8, "8位对齐")
        XCTAssertEqual(MemoryLayout<TestBoolCon>.stride, 16, "")

        XCTAssertEqual(MemoryLayout<Obj>.size, 8, "只是8位指针")
        XCTAssertEqual(MemoryLayout<Obj>.alignment, 8, "8位对齐")
        XCTAssertEqual(MemoryLayout<Obj>.stride, 8, "")
    }
}

extension MemoryLayoutTest {
    struct Test {
        // 1个字节bool + 8个字节的 Int + 1个字节的bool
        // size: 1 byte bool + 7 byte padding + 8 byte Int + 1 byte bool = 17 byte
        let res1: Bool = false //bool 占用1个字节
        let res2: Int = 0 // Int 占用8个字节（64位）
        let res3: Bool = false // Bool 占用 1个字节
    }

    struct TestBoolCon {
        // 1个字节bool  + 1个字节的bool + 8个字节的 Int
        // size: 1 byte bool + 1 byte bool + 6 byte padding + 8 byte Int = 16 byte
        let res1: Bool = false //bool 占用1个字节
        let res3: Bool = false // Bool 占用 1个字节
        let res2: Int = 0 // Int 占用8个字节（64位）
    }

    class Obj {
        var test1 = Test()
        var test2 = TestBoolCon()
        var str = "str"

        deinit {
            print("deinit")
        }
    }
}
