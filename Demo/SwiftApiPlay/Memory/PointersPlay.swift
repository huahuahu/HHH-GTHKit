//
//  PointersPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/3/26.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import Foundation
import XCTest
import Quick
import Nimble
import HHHKit

class PointerPlay: QuickSpec {
    //swiftlint:disable function_body_length
    override func spec() {
        describe("访问指针内存的方式") {
            let intNumber = 23
            let ptr: UnsafeMutablePointer<Int> = UnsafeMutablePointer.allocate(capacity: 1)
            ptr.initialize(to: intNumber)
            expect(ptr.pointee).to(equal(23))
            expect(ptr[0]).to(equal(23))
        }
        describe("以另一种类型访问内存") {
            //type-safe way to temporarily change the bound type of the memory
            it("可以临时改变Type", closure: {
                let intArray: [UInt8] = [0x80, 0x81, 0xa1, 0xff, 0x78, 0x10, 0x01, 0x08]
                let uint8Pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer.allocate(capacity: 8)
                uint8Pointer.initialize(from: intArray, count: 8)
                expect(uint8Pointer[0]).to(equal(0x80))
                expect(uint8Pointer[1]).to(equal(0x81))
                uint8Pointer.withMemoryRebound(to: Int8.self, capacity: 8, { (intPointer) in
                    expect(intPointer[0]).to(equal(-128))
                    expect(intPointer[1]).to(equal(-127))
                    expect(intPointer[7]).to(equal(8))
                })
            })
            //type-safe way to permanently change the bound type of the memory
            it("也可以永久访问Type", closure: {
                let intArray: [UInt8] = [0x80, 0x81, 0xa1, 0xff, 0x78, 0x10, 0x01, 0x08]
                let uint8Pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer.allocate(capacity: 8)
                uint8Pointer.initialize(from: intArray, count: 8)
                expect(uint8Pointer[0]).to(equal(0x80))
                expect(uint8Pointer[1]).to(equal(0x81))
                //永久改为UInt64类型
                let uint64Pointer = UnsafeRawPointer(uint8Pointer)
                    .bindMemory(to: UInt64.self, capacity: 1)
                // 小端序存储
                expect(uint64Pointer.pointee).to(equal(0x08011078_ffa18180))
                //⚠️⚠️⚠️⚠️⚠️
                //                var firstByte = uint8Pointer.pointee             // undefined
            })
            // load typed instances directly from raw memory
            it("untyped memory access", closure: {
                let intArray: [UInt8] = [0x80, 0x81, 0xa1, 0xff, 0x78, 0x10, 0x01, 0x08]
                let uint8Pointer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer.allocate(capacity: 8)
                uint8Pointer.initialize(from: intArray, count: 8)
                let rawPointer = UnsafeRawPointer(uint8Pointer)
                let fullInteger = rawPointer.load(as: UInt64.self)   // OK
                let firstByte = rawPointer.load(as: UInt8.self)      // OK
                expect(fullInteger).to(equal(0x08011078_ffa18180))
                expect(firstByte).to(equal(128))
            })
        }
        describe("typedPointer") {
            it("number to pointers", closure: {
                var aNumber = 10
                withUnsafePointer(to: aNumber, { (pointer)  in
                    expect(pointer.pointee).to(equal(10))
                    //Left side of mutating operator isn't mutable: 'pointee' is a get-only property
                    //pointer.pointee += 1
                    //不能调用这个，pointer being freed was not allocated
                    //pointer.deallocate()
                    //⚠️ 这个值是未定义的！！
                    let succ = pointer.successor()
                    print("get random number \(succ.pointee)")
                    //                pointer.pointee += 1
                })
                withUnsafeMutablePointer(to: &aNumber, { (pointer) in
                    pointer.pointee += 1
                    expect(pointer.pointee).to(equal(11))
                })
                expect(aNumber).to(equal(11))
                withUnsafePointer(to: aNumber, { (pointer) in
                    pointer.withMemoryRebound(to: UInt8.self, capacity: 8, { (uint8Pointer)  in
                        let data = Data.init(bytes: uint8Pointer, count: 8)
                        let strMemory = data.hexView
                        expect(strMemory).to(equal("0b_00_00_00_00_00_00_00"))
                        print(strMemory)
                    })
                })
            })

            describe("pointer to class", closure: {
                let pointer: UnsafeMutablePointer<PointerTestClass> = UnsafeMutablePointer.allocate(capacity: 3)
                let testInstance = PointerTestClass()
                pointer.initialize(repeating: testInstance, count: 3)
                // ⚠️ 下面这个会报错，因为还处于 uninit 状态
//                pointer.assign(repeating: testInstance, count: 3)
                testInstance.intNum = 4
                //改了一个，所有的都会改，因为指向了同一个地址。
                expect(pointer.pointee.intNum).to(equal(4))
                expect(pointer[1].intNum).to(equal(4))
                expect(pointer[2].intNum).to(equal(4))
                // 证明是同一个地址
                var instanceAddress: String!
                withUnsafeBytes(of: testInstance, { (rawBuffer) in
                    let data = Data.init(bytes: rawBuffer.baseAddress!, count: rawBuffer.count)
                    instanceAddress = data.hexView
                })
                (0..<3).forEach({ (offset) in
                    pointer.advanced(by: offset).withMemoryRebound(to: UInt8.self, capacity: 8, { (uInt8Pointer) in
                        let data = Data.init(bytes: uInt8Pointer, count: 8)
                        expect(data.hexView).to(equal(instanceAddress))
                    })
                })
            })
            describe("pointer to struct", {
                let pointer: UnsafeMutablePointer<PointerTestStruct> = UnsafeMutablePointer.allocate(capacity: 3)
                var testInstance = PointerTestStruct()
                //可以用assign，因为是 trival type
                pointer.assign(repeating: testInstance, count: 3)
                testInstance.intNum = 4
                //改了一个，其他的不会受影响，因为是不同的实例。
                expect(pointer.pointee.intNum).to(equal(3))
                expect(pointer[1].intNum).to(equal(3))
                expect(pointer[2].intNum).to(equal(3))

                var memory: String!
                let stride = MemoryLayout.stride(ofValue: testInstance)
                withUnsafeBytes(of: testInstance, { (rawBuffer) in
                    let data = Data.init(bytes: rawBuffer.baseAddress!, count: rawBuffer.count)
                    memory = data.hexView
                })
                (0..<3).forEach({ (offset) in
                    pointer.advanced(by: offset).withMemoryRebound(to: UInt8.self, capacity: stride, { (uInt8Pointer) in
                        let data = Data.init(bytes: uInt8Pointer, count: stride)
                        expect(data.hexView).toNot(equal(memory))
                    })
                })
            })
        }
    }
}

struct PointerTestStruct {
    var intNum = 3
    var another = 56
    var another1 = 59
}

class PointerTestClass {
    var intNum = 3
    var another = 56
    var another1 = 59
}

extension Data {
    var hexView: String {
        return map({String.init(format: "%02x", $0)}).joined(separator: "_")
    }
}
