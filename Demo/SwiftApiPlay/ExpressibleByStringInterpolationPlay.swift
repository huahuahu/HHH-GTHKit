//
//  ExpressibleByStringInterpolationPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/2/20.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Foundation
import CoreFoundation

class ExpressibleByStringInterpolationPlay: XCTestCase {
}

//https://nshipster.com/expressiblebystringinterpolation/
//swiftlint:disable function_body_length
class ExpressibleByStringInterpolationSpec: QuickSpec {
    override func spec() {
        let dataComponent = DateComponents.init(year: 2019, month: 12, day: 31)
        let date = Calendar.current.date(from: dataComponent)!

        it("YYYY not OK") {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            //swiftlint:disable line_length
            //            (😱)  YYYY 不对，应该是yyyy
//             "YYYY" is the format for the ISO week-numbering year, which returns 2020 for December 31st, 2019 because the following day is a Wednesday in the first week of the new year.
            //swiftlint:enable line_length
            expect(formatter.string(from: date)).to(equal("2020-12-31"))
            formatter.dateFormat = "yyyy-MM-dd"
            expect(formatter.string(from: date)).to(equal("2019-12-31"))
            // DSLs are dangerous-but-expressive
            //ExpressibleByStringInterpolation are correct(less-dangerous) and expressive
        }

        it("Extending Default String Interpolation demo") {
            var str = "\(date, component: .year)-\(date, component: .month)-\(date, component: .day)"
            expect(str).to(equal("2019-12-31"))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .none
            str = "Today is \(date, formatter: dateFormatter)"
            expect(str).to(equal("Today is Tuesday, December 31, 2019"))

            let numberformatter = NumberFormatter()
            numberformatter.numberStyle = .spellOut
            str = "one plus one is \(1 + 1, formatter: numberformatter)"
            expect(str).to(equal("one plus one is two"))
        }
        it("Implementing a Custom String Interpolation Type Demo") {
            let name = "<bobby>"
            var markup: XMLEscapedString = "<p>Hello, \(name)!</p>"
            expect(markup.description).to(equal("<p>Hello, &lt;bobby&gt;!</p>"))

            var interpolation = XMLEscapedString.StringInterpolation(literalCapacity: 15, interpolationCount: 1)
            interpolation.appendLiteral("<p>Hello, ")
            interpolation.appendInterpolation(name)
            interpolation.appendLiteral("!</p>")
            markup = XMLEscapedString(stringInterpolation: interpolation)
            expect(markup.description).to(equal("<p>Hello, &lt;bobby&gt;!</p>"))
        }
        it("condition append") {
            var isStarred = true
            var str = "Cheese Sandwich \(if: isStarred, "(*)")"
            expect(str).to(equal("Cheese Sandwich (*)"))
            isStarred = false
            str = "Cheese Sandwich \(if: isStarred, "(*)")"
            expect(str).to(equal("Cheese Sandwich "))
        }

        it("optional not need") {
            var value1: Int?
            value1 = nil
            var value2: Int?
            value2 = 12
            let str = "There's \(value1, default: "nil") and \(value2, default: "nil")"
            expect(str).to(equal("There's nil and 12"))
        }
    }
}

#if swift(<5)
#error("Download Xcode 10.2 Beta 2 to see this in action")
#endif

//String.StringInterpolation 和 DefaultStringInterpolation 等价
extension String.StringInterpolation {
    /// 只有 `condition` 的返回值为 `true` 才进行插值
    mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
        guard condition() else { return }
        appendLiteral(literal)
    }

    /// 提供 `Optional` 字符串插值
    /// 而不必强制使用 `String(describing:)`
    public mutating func appendInterpolation<T>(_ value: T?, default defaultValue: String) where T: CustomStringConvertible {
        if let value = value {
            appendInterpolation(value)
        } else {
            appendLiteral(defaultValue)
        }
    }
}

extension DefaultStringInterpolation {
    mutating func appendInterpolation(_ value: Date,
                                      component: Calendar.Component) {
        let dateComponents =
            Calendar.current.dateComponents([component],
                                            from: value)

        self.appendInterpolation(
            dateComponents.value(for: component)!
        )
    }

    mutating func appendInterpolation(_ value: Date,
                                      formatter: DateFormatter) {
        self.appendInterpolation(
            formatter.string(from: value)
        )
    }
    //swiftlint:disable force_cast
    mutating func appendInterpolation<T>(_ value: T, formatter: NumberFormatter) where T: Numeric {
        self.appendInterpolation(
            formatter.string(from: value as! NSNumber)!
        )
    }

}

struct XMLEscapedString: LosslessStringConvertible {
    var value: String

    init?(_ value: String) {
        self.value = value
    }

    var description: String {
        return self.value
    }
}

extension XMLEscapedString: ExpressibleByStringInterpolation {
    init(stringLiteral value: String) {
        self.init(value)!
    }

    init(stringInterpolation: StringInterpolation) {
        self.init(stringInterpolation.value)!
    }

    struct StringInterpolation: StringInterpolationProtocol {
        var value: String = ""

        init(literalCapacity: Int, interpolationCount: Int) {
            self.value.reserveCapacity(literalCapacity)
        }

        mutating func appendLiteral(_ literal: String) {
            self.value.append(literal)
        }

        mutating func appendInterpolation<T>(_ value: T)
            where T: CustomStringConvertible {
                //swiftlint:disable line_length
                // available on macos
                // let escaped = CFXMLCreateStringByEscapingEntities(nil, value.description as NSString, nil)! as NSString

                let escaped = value.description.map { (char) -> String in
                    if char == "<" {
                        return "&lt;"
                    } else if char == ">" {
                        return "&gt;"
                    } else {
                        return String.init(char)
                    }
                    }.joined()
                self.value.append(escaped)
        }
    }
}
