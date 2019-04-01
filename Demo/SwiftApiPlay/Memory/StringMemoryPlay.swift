//
//  File.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/3/28.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import Foundation
import XCTest
import Quick
import Nimble
import HHHKit

class StringMemoryPlay: QuickSpec {
    //swiftlint:disable function_body_length
    override func spec() {
        describe("small string") {
            func checkLength(_ smallstr: String) {
                let utf8Count: UInt8 = UInt8(smallstr.utf8.count)
                withUnsafeBytes(of: smallstr, { (bufferBytePointer) in
                    // 小字符串只有16字节
                    expect(bufferBytePointer.count).to(be(16))
                    let count: UInt8 = bufferBytePointer.last! & 0x0F
                    let zero: UInt8 = 0
                    expect(count - utf8Count).to(be(zero))
                    print("\(smallstr), utf8Length is \(count)")
                })
            }
            func checkAscii(_ smallStr: String) {
                withUnsafeBytes(of: smallStr, { (bufferBytePointer) in
                    // 小字符串只有16字节
                    expect(bufferBytePointer.count).to(be(16))
                    let discriminator = bufferBytePointer.last! & 0xF0
                    let isAscii = !smallStr.unicodeScalars.contains { !$0.isASCII }
                    print("\(smallStr), isAscii? \(isAscii)")
                    if isAscii {
                        let asciiDis: UInt8 = 0xe0
                        expect(discriminator).to(be(asciiDis))
                    } else {
                        let noAsciiDis: UInt8 = 0xa0
                        expect(discriminator).to(be(noAsciiDis))
                    }
                })
            }
            func checkCodePoints(_ smallStr: String) {
                withUnsafeBytes(of: smallStr, { (bufferBytePointer) in
                    // 小字符串只有16字节
                    expect(bufferBytePointer.count).to(be(16))
                    print("utf8 points: \(smallStr.utf8.map({String.init(format: "%02x", $0)}).joined(separator: "_"))")
                    smallStr.utf8.enumerated().forEach({ (offset, point) in
                        expect(point).to(equal(bufferBytePointer[offset]))
                    })
                    let rawBytes = bufferBytePointer.map({String.init(format: "%02x", $0)}).joined(separator: "_")
                    print("raw bytes:   \(rawBytes)")
                })
            }
            func check(_ smallStr: String) {
//                print("-------------smallStr------------------------")
//                checkLength(smallStr)
//                checkAscii(smallStr)
//                checkCodePoints(smallStr)
            }
            it("表示ascii", closure: {
                let smallstr = "123"
                check(smallstr)
            })
            it("最长15个", closure: {
                let smallstr = "1234567890abcde"
                check(smallstr)
            })
            it("表示非ascii", closure: {
                let smallstr = "iIIïœ"
                check(smallstr)
            })
            it("表示emoji", closure: {
                //31
                //F0 9F 90 AF
                //31
                //31 E2 83 A3 EF B8 8F
                //31
                let smallstr = "1🐯11⃣️1"
                check(smallstr)
            })
        }

        describe("large string") {
            func checkIsAscii(_ largeStr: String) {
                withUnsafeBytes(of: largeStr, { (bytesPointer) in
                    let flags = (bytesPointer.first! & 0xf0) >> 4
                    let flagIsAscii = flags & 0x80
                    let isAscii = !largeStr.unicodeScalars.contains { !$0.isASCII }
                    print("is Ascii: \(isAscii)")
                    expect(flagIsAscii != 0).to(equal(isAscii))
                })
            }

            func checkTailAlloc(_ largeStr: String) {
                withUnsafeBytes(of: largeStr, { (bytesPointer) in
                    let flags = (bytesPointer.first! & 0xf0) >> 4
                    let isTailAllocate = flags & 0x1
                    expect(isTailAllocate).to(equal(1))
                })
            }

            func checkCount(_ largeStr: String) {
                let utf8Count = largeStr.utf8.count
                withUnsafeBytes(of: largeStr, { (bytesPointer) in
                    let count = bytesPointer.baseAddress!.load(as: UInt64.self) & 0x00ffffff_ffffffff
                    expect(count).to(be(utf8Count))
                    print("utftCount is \(count)")
                })
            }
            func checkDiscriminator(_ largeStr: inout String) {
                withUnsafeBytes(of: largeStr, { (bytesPointer) in
                    let lastInt = bytesPointer.baseAddress!.load(fromByteOffset: 15, as: UInt8.self)
                    let discriminator = lastInt & 0xf0
                    let zero: UInt8 = 0
                    expect(discriminator - 0x80).to(be(zero))
                })
            }
            func checkStringObject(_ largeStr: String) {
                let address = withUnsafeBytes(of: largeStr, { (bytesPointer) -> UInt64 in
                    return bytesPointer.baseAddress!.load(fromByteOffset: 8, as: UInt64.self) & 0x0fffffff_ffffffff
                })
                print("address: \(address.toStringView)")
                let rawPointer = UnsafeRawPointer(bitPattern: UInt(address))!
                let metadata = rawPointer.load(fromByteOffset: 0, as: UInt64.self).toStringView
                print("metadata: \(metadata)")
                let refCounts = rawPointer.load(fromByteOffset: 8, as: UInt64.self).toStringView
                print("refCounts: \(refCounts)")
                let capAndFlags = rawPointer.load(fromByteOffset: 16, as: UInt64.self).toStringView
                print("capAndFlags: \(capAndFlags)")
                let countAndFlags = rawPointer.load(fromByteOffset: 24, as: UInt64.self).toStringView
                print("countAndFlags: \(countAndFlags)")

                let utfPoints = rawPointer.advanced(by: 32).bindMemory(to: UInt8.self, capacity: largeStr.utf8.count)
                print("utf8 inMemory:")
                //swiftlint:disable line_length
                largeStr.utf8.enumerated().forEach(({ (offset, point) in
                    print(String.init(format: "%02x", utfPoints.advanced(by: offset).pointee), separator: "_", terminator: "_")
                    expect(utfPoints.advanced(by: offset).pointee).to(equal(point))
                }))
            }
//            func checkDiscriminatorImmortal(_ largeStr: String) {
//                withUnsafeBytes(of: largeStr, { (bytesPointer) in
//                    let secondInt = bytesPointer.baseAddress!.load(fromByteOffset: 8, as: UInt64.self)
//                    let discriminator = secondInt & 0xf0
//                    expect(discriminator).to(be(0))
//                })
//
//            }

            func check(_ largeStr: inout String) {
                print("----large:== \(largeStr) ==------------")
                print("utf8 points:\n\(largeStr.utf8.map({String.init(format: "%02x", $0)}).joined(separator: "_"))")
                let size = MemoryLayout.size(ofValue: largeStr)
                expect(size).to(be(16))
                let stride = MemoryLayout.stride(ofValue: largeStr)
                expect(stride).to(be(16))
//                checkIsAscii(largeStr)
                checkCount(largeStr)
//                checkTailAlloc(largeStr)
                checkDiscriminator(&largeStr)
                checkStringObject(largeStr)
            }
//            it("检测可变形", closure: {
//                let largeStr = "1🐯11⃣️1🇺🇸1"
//                checkDiscriminatorImmortal(largeStr)
//                var largeStr1 = "1🐯11⃣️1🇺🇸1"
//                checkDiscriminator(&largeStr1)
//                largeStr1 += "hha"
//                print(largeStr1)
//            })
            it("表示emoji", closure: {
                //31
                //F0 9F 90 AF
                //31
                //31 E2 83 A3 EF B8 8F
                //31
                //F0 9F 87 BA F0 9F 87 B8
                //31
                var largeStr = "1🐯11⃣️1🇺🇸1"
                check(&largeStr)
                print("\n")
                largeStr += "hha"
                print(largeStr)
            })
            it("表示中文", closure: {
                var largeStr = "我喜欢你，你知不知道"
                check(&largeStr)
                print("\n")
                largeStr += "hha"
                print(largeStr)
            })
        }
    }
}

extension UInt64 {
    var toStringView: String {
        let str = String.init(self, radix: 16, uppercase: false)
        let count = str.count
        return "0x" + String.init(repeating: "0", count: (16 - count)) + str
    }

}
