//
//  DemoTests.swift
//  DemoTests
//
//  Created by huahuahu on 2018/12/7.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest
@testable import Demo
@testable import HHHKit
import Quick
import Nimble

class TestStringExt: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitFormHex() {
        var hex = "fffe6400"
        var str = String.init(hexString: hex, encodingTye: .utf16)
        XCTAssertEqual(str!, "d", "d utf16 编码后为 fffe640")

        hex = "fFfE6400"
        str = String.init(hexString: hex, encodingTye: .utf16)
        XCTAssertEqual(str!, "d", "大小写不敏感")

        hex = "👌dfdf"
        str = String.init(hexString: hex, encodingTye: .utf8)
        XCTAssertNil(str, "hex string 不是 alphanumerics")

        hex = "dfdfuy"
        str = String.init(hexString: hex, encodingTye: .utf8)
        XCTAssertNil(str, "hex string 有除了 a-f之外的d字符")

        hex = "fFfE64003"
        str = String.init(hexString: hex, encodingTye: .utf8)
        XCTAssertNil(str, "hex string 必须是偶数个")
    }

    func testUnicodeEncodedDataStr() {

        var testStr = "simple text"
        testUtf8Encode(str: testStr)
        testUtf8Encode(str: testStr)
        testUtf8Encode(str: testStr)

        testUtf16Encode(str: testStr, encodeType: .utf16)
        testUtf16Encode(str: testStr, encodeType: .utf16LittleEndian)
        testUtf16Encode(str: testStr, encodeType: .utf16BigEndian)

        testUtf32Encode(str: testStr, encodeType: .utf32)
        testUtf32Encode(str: testStr, encodeType: .utf32BigEndian)
        testUtf32Encode(str: testStr, encodeType: .utf32LittleEndian)

        testStr = "with cjk 我是一个好人"
        testUtf8Encode(str: testStr)
        testUtf8Encode(str: testStr)
        testUtf8Encode(str: testStr)

        testUtf16Encode(str: testStr, encodeType: .utf16)
        testUtf16Encode(str: testStr, encodeType: .utf16LittleEndian)
        testUtf16Encode(str: testStr, encodeType: .utf16BigEndian)

        testUtf32Encode(str: testStr, encodeType: .utf32)
        testUtf32Encode(str: testStr, encodeType: .utf32BigEndian)
        testUtf32Encode(str: testStr, encodeType: .utf32LittleEndian)

        testStr = "with emoji 🇨🇳 🇺🇸 🌹🌹🐯"
        testUtf8Encode(str: testStr)
        testUtf8Encode(str: testStr)
        testUtf8Encode(str: testStr)

        testUtf16Encode(str: testStr, encodeType: .utf16)
        testUtf16Encode(str: testStr, encodeType: .utf16LittleEndian)
        testUtf16Encode(str: testStr, encodeType: .utf16BigEndian)

        testUtf32Encode(str: testStr, encodeType: .utf32)
        testUtf32Encode(str: testStr, encodeType: .utf32BigEndian)
        testUtf32Encode(str: testStr, encodeType: .utf32LittleEndian)
    }

    /// 测试Decode
    func testUTFDecode() {
//        string: ok
//        utf8 6F_6B
//        utf16 006f_006b
//        utf32 0000006f_0000006b
        let str = "ok"
        var testStr = "6f6b"
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf8), str, "utf8一致")

        // utf16
        testStr = "feff006f006b" //大端序，带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf16), str, "utf16 通过bom指定大端序")
        testStr = "fffe6f006b00" // 小端序，带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf16), str, "utf16 通过bom指定小端序")
        testStr = "006f006b" // 大端序，不带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf16BigEndian), str, "utf16没有bom，指定大端序")

        testStr = "6f006b00" // 小端序，不带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf16LittleEndian), str, "utf16没有bom，指定小端序")

        //utf32
        testStr = "0000feff0000006f0000006b" //大端序，带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf32), str, "utf32 通过bom指定大端序")
        testStr = "fffe00006f0000006b000000" // 小端序，带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf32), str, "utf32 通过bom指定小端序")
        testStr = "0000006f0000006b" // 大端序，不带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf32BigEndian), str, "utf32没有bom，指定大端序")

        testStr = "6f0000006b000000" // 小端序，不带bom
        XCTAssertEqual(String.init(hexString: testStr, encodingTye: .utf32LittleEndian), str, "utf32没有bom，指定小端序")
    }
}

// MARK: - 测试各种编码
extension TestStringExt {
    func testUtf8Encode(str: String) {
        let utf8Str1 = str.utf8.map { String.init(format: "%02x", $0) }.joined(separator: "")
        let utf8Str2 = str.asciiViewOf(encodingType: .utf8)!
        XCTAssertEqual(utf8Str1, utf8Str2, "系统方法和自己写的方法对UTF8编码不一致")
    }

//    FE FF    = UTF-16, big-endian    (大尾字节序标记)
//    FF FE    = UTF-16, little-endian (小尾字节序标记) (也是windows中的Unicode编码默认标记)
    func testUtf16Encode(str: String, encodeType: String.Encoding) {
        let validEncoding: Set<String.Encoding> = [.utf16, .utf16BigEndian, .utf16LittleEndian]
        guard validEncoding.contains(encodeType) else {
            XCTFail("不支持的编码类型 \(encodeType)")
            return
        }

        let strFromUtfView: String = {
            let isBigEndianOrder = (encodeType == .utf16BigEndian) || (encodeType == .utf16 && isBigEndian())
            //确定bom
            let bom: String = {
                //没有指定大小，才需要bom
                if encodeType != .utf16 { return ""}
                return isBigEndian() ? "feff" : "fffe"
            }()
            return bom + str.utf16.map({ return isBigEndianOrder ? $0.bigEndianHex : $0.littleEndianHex}).joined()
        }()

        let strFromData = str.asciiViewOf(encodingType: encodeType)!
        XCTAssertEqual(strFromUtfView.lowercased(), strFromData.lowercased(), "系统方法和自己写的方法对UTF16编码不一致, \(encodeType)")
    }

//    00 00 FE FF = UTF-32, big-endian   (大尾字节序标记)
//    FF FE 00 00 = UTF-32, little-endian (小尾字节序标记)
    func testUtf32Encode(str: String, encodeType: String.Encoding) {
        let validEncoding: Set<String.Encoding> = [.utf32, .utf32BigEndian, .utf32LittleEndian]
        guard validEncoding.contains(encodeType) else {
            XCTFail("不支持的编码类型 \(encodeType)")
            return
        }

        let strFromUtfView: String = {
            let isBigEndianOrder = (encodeType == .utf32BigEndian) || (encodeType == .utf32 && isBigEndian())
            //确定bom
            let bom: String = {
                //没有指定大小，才需要bom
                if encodeType != .utf32 { return ""}
                return isBigEndian() ? "0000feff" : "fffe0000"
            }()
            return bom + str.unicodeScalars.map {
                return isBigEndianOrder ? $0.value.bigEndianHex : $0.value.littleEndianHex}.joined()
        }()

        let strFromData = str.asciiViewOf(encodingType: encodeType)!
        XCTAssertEqual(strFromUtfView.lowercased(), strFromData.lowercased(), "系统方法和自己写的方法对UTF32编码不一致, \(encodeType)")
    }
}

extension TestStringExt {
    func testUrlMatch() {
        var str = "http://baidu.com"
        XCTAssertEqual(str.links, [URL.init(string: "http://baidu.com")!])

        str = "http://baidu.com dfa"
        XCTAssertEqual(str.links, [URL.init(string: "http://baidu.com")!])

        str = "fdas http://baidu.com dfa"
        XCTAssertEqual(str.links, [URL.init(string: "http://baidu.com")!])

        str = "fdas http://baidu.com?dfa=90 dfa"
        XCTAssertEqual(str.links, [URL.init(string: "http://baidu.com?dfa=90")!])

        str = "fdas http://baidu.com:80?dfd=89d dfa"
        XCTAssertEqual(str.links, [URL.init(string: "http://baidu.com:80?dfd=89d")!])

        str = "fdas http://baidu.com:80?dfd=89d dfa"
        str += str
        var url = URL.init(string: "http://baidu.com:80?dfd=89d")!
        XCTAssertEqual(str.links, Array.init(repeating: url, count: 2))

        str = "fdas ftp://baidu.com:80?dfd=89d dfa"
        url = URL.init(string: "ftp://baidu.com:80?dfd=89d")!
        XCTAssertEqual(str.links, Array.init(repeating: url, count: 1))
    }
}

class Wrapper: QuickSpec {

    class Example {
        var value = ""
    }

    override func spec() {
        describe("Wrapped Weak Test") {
            it("被其他对象持有时，可以取到值") {
                let expObj = Example.init()
                let weakWrap = Weak<Example>()
                weakWrap.value = expObj
                expect(weakWrap.value).toNot(beNil())
            }
            it("没有被其他对象持有时，取到的值时是nil") {
                var expObj: Example? = Example.init()
                var array = [expObj]
                let weakWrap = Weak<Example>()
                weakWrap.value = expObj
                expObj = nil
                array.removeAll()
                expect(weakWrap.value).to(beNil())
            }
        }
    }
}

class EncryptString: QuickSpec {
    override func spec() {
        describe("encrypt check") {
            it("md5 right", closure: {
                expect("huahuahu".md5()).to(equal("c0b7bf0c417a758d2949eb6bee37800e"))
                expect("HUAHUAHU".md5()).to(equal("69572aeb13a540699a84af7ce2b79255"))
            })
            it("sha1 right", closure: {
                expect("huahuahu".sha1()).to(equal("36eda0c2b96f129cc40e64705a7c4fe3dc7f5a08"))
                expect("HUAHUAHU".sha1()).to(equal("a8a0e07b5f1658ebf55790bca3bf3978064948b9"))
            })
        }
    }
}
