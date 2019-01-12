//
//  StringPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/11.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest

class StringPlay: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class."
    }

    func testUnicode() {
//        😂
//        笑出眼泪
//        Unicode: U+1F602，UTF-8: F0 9F 98 82
//        🇮🇪
//        爱尔兰国旗
//        Unicode: U+1F1EE U+1F1EA，UTF-8: F0 9F 87 AE F0 9F 87 AA
        let str = String.init(decoding: [0xF0, 0x9F, 0x98, 0x82], as: UTF8.self)
        XCTAssertEqual(str, "😂")
        print("\\N{FACE WITH TEARS OF JOY}".applyingTransform(.toUnicodeName,
                                                              reverse: true) ?? "")
        print("🥳✨".applyingTransform(.toUnicodeName, reverse: false)!)
        print("niubi 🐂🆚👃".applyingTransform(.toUnicodeName, reverse: false)!)
        print("窗前明月光".applyingTransform(.mandarinToLatin, reverse: false)!)
        print("重庆 重量 张诗园".applyingTransform(.mandarinToLatin, reverse: false)!)
    }

}
