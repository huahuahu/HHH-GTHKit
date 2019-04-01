//
//  StringPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/11.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Foundation
//swfitlint:disable function_body_length

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

class SwiftStringPlay: QuickSpec {
//    https://juejin.im/post/5c4e83566fb9a049b2224325
    override func spec() {
        describe("原始字符串") {
            it("去掉了转义操作", closure: {
                let regularString = "\\Hello \\World"
                let rawString = #"\Hello \World"#
                expect(regularString).to(equal(rawString))
            })
            it("原始字符串里嵌入变量", closure: {
                let name = "Taylor"
                let greeting = #"Hello, \(name) is  \#(name)!"#
                expect(greeting).to(equal("Hello, \\(name) is  Taylor!"))
            })
        }
    }
}

class RegexPlaySpec: QuickSpec {
    //    https://nshipster.com/swift-regular-expressions/
    //swiftlint:disable function_body_length
    override func spec() {
        it("正确识别正则表达式") {
            let invitation = "Fancy a game of Cluedo?"
            //\b: word boundary
            let range = invitation.range(of: #"\bClue(do)?\b"#, options: .regularExpression)
            let matchedStr = invitation[range!]
            expect(matchedStr).to(equal("Cluedo"))
        }

        it("可以正确替换") {
            let instructions = "murder of Dr. Black"
            let replaced = instructions.replacingOccurrences(
                of: #"(Dr\.|Doctor) Black"#,
                with: "Mr. Boddy",
                options: .regularExpression
            )
            expect(replaced).to(equal("murder of Mr. Boddy"))
        }
        it("Capture Groups demo") {
            let description = "Cluedo is a game of skill for 2-6 players."
            //two capture groups (\d+) (\d+)
            // Pd:  Unicode General Category Pd (Punctuation, dash)
            // \p{UNICODE PROPERTY NAME} Match any character with the specified Unicode Property.
            let pattern = #"(\d+)[ \p{Pd}](\d+) players"#
            let regex = try? NSRegularExpression(pattern: pattern, options: [])

            var playerRange: ClosedRange<Int>?
            let nsrange = NSRange(description.startIndex..<description.endIndex,
                                  in: description)
            regex?.enumerateMatches(in: description,
                                    options: [],
                                    range: nsrange) { (match, _, stop) in
                                        guard let match = match else { return }

                                        if match.numberOfRanges == 3, //两个 Capture Groups，一个全部
                                            //第一个 Capture Groups
                                            let firstCaptureRange = Range(match.range(at: 1),
                                                                          in: description),
                                            // 第二个 Capture Groups
                                            let secondCaptureRange = Range(match.range(at: 2),
                                                                           in: description),
                                            let lowerBound = Int(description[firstCaptureRange]),
                                            let upperBound = Int(description[secondCaptureRange]),
                                            lowerBound > 0 && lowerBound < upperBound {
                                            playerRange = lowerBound...upperBound
                                            stop.pointee = true
                                        }
            }

            expect(playerRange!.lowerBound).to(equal(2))
            expect(playerRange!.upperBound).to(equal(6))
        }
        it("Named Capture Groups demo") {
            let suggestion = "I suspect it was Professor Plum in the Dining Room with the Candlestick."
            let pattern = #"(?<suspect>Professor Plum) in the"#
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let nsrange = NSRange(suggestion.startIndex..<suggestion.endIndex,
                                  in: suggestion)
            if let match = regex?.firstMatch(in: suggestion,
                                             options: [],
                                             range: nsrange) {
                for component in ["suspect"] {
                    let nsrange = match.range(withName: component)
                    if nsrange.location != NSNotFound,
                        let range = Range(nsrange, in: suggestion) {
                        expect(suggestion[range]).to(equal("Professor Plum"))
                    }
                }
            }
        }
    }
}
