//
//  FormatPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/7/29.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Foundation
import Contacts

//swiftlint:disable function_body_length
//swiftlint:disable identifier_name
//https://nshipster.com/formatter/
class FormaterSpec: QuickSpec {
    override func spec() {
//        testNumber()
//        testMeasurementFormatter()
//        testDate()
//        testNameAndPlace()
        testListFormatter()
    }

    private func testNumber() {
        it("numberFormat 不同输出") {
            let number = -123.456
            let formatter = NumberFormatter.init()
            let styles: [NumberFormatter.Style] = [.none, //An integer representation
                                                   .decimal,
                                                   .scientific,
                                                   .spellOut,
                                                   .ordinal, //序列
                                                   .currency,
                                                   .currencyAccounting, //负数被括号包起来
                                                   .currencyISOCode, //ISO 4217 currency code
                                                   .currencyPlural, //corresponding 名称复数
                                                   .percent]
            styles.forEach { (style) in
                formatter.numberStyle = style
                let str = formatter.string(from: NSNumber(value: number))
                print("\(number) in \(style) is \(str)")
            }
        }
        describe("用 numberFormat 取整") {
            context("usesSignificantDigits true") {
                it("有意义的数位") {
                    let formatter = NumberFormatter()
                    formatter.usesSignificantDigits = true
                    formatter.minimumSignificantDigits = 1 // default
                    formatter.maximumSignificantDigits = 6 // default

                    print(formatter.string(from: 1234567)) // 1234570
                    print(formatter.string(from: 1234.567)) // 1234.57
                    print(formatter.string(from: 100.234567)) // 100.235
                    print(formatter.string(from: 1.23000)) // 1.23
                    print(formatter.string(from: 0.0000123)) // 0.0000123
                }
            }
            context("usesSignificantDigits false") {
                it("小数点前后的数位") {
                    let formatter = NumberFormatter()
                    formatter.usesSignificantDigits = false
                    formatter.minimumIntegerDigits = 0 // default
                    formatter.maximumIntegerDigits = 42 // default (seriously)
                    formatter.minimumFractionDigits = 0 // default
                    formatter.maximumFractionDigits = 0 // default
                    formatter.roundingMode = .up

                    print(formatter.string(from: 1234567)) // 1234567
                    print(formatter.string(from: 1234.567)) // 1235
                    print(formatter.string(from: 100.234567)) // 100
                    print(formatter.string(from: 1.23000)) // 1
                    print(formatter.string(from: 0.0000123)) // 0
                }
            }
        }
    }

    private func testMeasurementFormatter() {
        it("例子") {
            // "The swift (Apus apus) can power itself to a speed of 111.6km/h"
            let speed = Measurement<UnitSpeed>(value: 111.6,
                                               unit: .kilometersPerHour)

            let formatter = MeasurementFormatter()
            var str = formatter.string(from: speed) // 69.345 mph
            print(str)
//            delegating much of its formatting responsibility to an underlying NumberFormatter property
            formatter.numberFormatter.usesSignificantDigits = true
            formatter.numberFormatter.maximumSignificantDigits = 4
            str = formatter.string(from: speed) // 69.35 mph
            print(str)
            //改变单位
            formatter.unitOptions = [.providedUnit, .naturalScale]
            print(formatter.string(from: speed)) // 111.6 km/h
            // 转为了 miles/hour
            print(formatter.string(from: speed.converted(to: .milesPerHour))) // 69.35 mph
        }
    }

    private func testDate() {
        describe("DateFormatter") {
            it("预设的date/time style") {
                let date = Date()

                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .long

                print(formatter.string(from: date))
                // July 15, 2019 at 9:41:00 AM PST

                formatter.dateStyle = .short
                formatter.timeStyle = .short
                print(formatter.string(from: date))
                // "7/16/19, 9:41:00 AM"
            }
            it("可以单独设置") {
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .medium

                let string = formatter.string(from: Date())
                // 9:41:00 AM
                print(string)
            }
        }
        describe("ISO8601DateFormatter") {
            it("原生支持") {
                let formatter = ISO8601DateFormatter()
                let string = formatter.date(from: "2019-07-15T09:41:00-07:00") // Jul 15, 2019 at 9:41 AM
                print("ISO8601DateFormatter got " + (string?.description ?? ""))
            }
            it("JSON Encoder 支持") {
                let json = #"""
                        [{
                            "body": "Hello, world!",
                            "timestamp": "2019-07-15T09:41:00-07:00"
                        }]
                        """#.data(using: .utf8)!

                struct Comment: Decodable {
                    let body: String
                    let timestamp: Date
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let comments = try? decoder.decode([Comment].self, from: json)
                let timeStamp = comments!.first?.timestamp // Jul 15, 2019 at 9:41 AM
                print("decoded timeStamp is \(timeStamp)")
            }

        }
        describe("DateIntervalFormatter") {
            let formatter = DateIntervalFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none

            let fromDate = Date()
            let toDate = Calendar.current.date(byAdding: .day, value: 7, to: fromDate)!

            let str = formatter.string(from: fromDate, to: toDate)
            // "7/15/19 – 7/22/19"
            print("DateIntervalFormatter example: " + str)
        }
        describe("busness hours") {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "en_US")
            print("en_US shortWeekdaySymbols:")
            print(calendar.shortWeekdaySymbols)
            // ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

            calendar.locale = Locale(identifier: "ja_JP")
            print("JP shortWeekdaySymbols:")
            print(calendar.shortWeekdaySymbols)
            // ["日", "月", "火", "水", "木", "金", "土"]

        }
        describe("DateComponentsFormatter") {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .spellOut

            let components = DateComponents(day: 1, hour: 2)

            let string = formatter.string(from: components)!
            // 1 day, 2 hours
            print("components: " + string)
        }
        describe("Formatting Context") {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .spellOut

            let components = DateComponents(hour: 2, minute: 10)

            let string = formatter.string(from: components)!
            // 1 day, 2 hours
            print("components: " + string)
            formatter.formattingContext = .beginningOfSentence
            print("beginningOfSentence: \(formatter.string(from: components)!)")
            formatter.formattingContext = .listItem
            print("listItem: \(formatter.string(from: components)!)")
            formatter.formattingContext = .standalone
            print("standalone: \(formatter.string(from: components)!)")
            formatter.formattingContext = .middleOfSentence
            print("middleOfSentence: \(formatter.string(from: components)!)")

        }
        describe("RelativeDateTimeFormatter") {
            if #available(iOS 13.0, *) {
                let formatter = RelativeDateTimeFormatter()
                formatter.locale = Locale.init(identifier: "zh_CN")
                formatter.unitsStyle = .short
                formatter.dateTimeStyle = .named // 今天/明天/后天
                print("RelativeDateTimeFormatter begin")
                print(formatter.localizedString(from: DateComponents(day: 1, hour: 1))) // "in 1 day"
                print(formatter.localizedString(from: DateComponents(day: -1))) // "1 day ago"
                print(formatter.localizedString(from: DateComponents(hour: 3))) // "in 3 hours"
                print(formatter.localizedString(from: DateComponents(minute: 60))) // "in 60 minutes"
                print("RelativeDateTimeFormatter end")
            } else {
                // Fallback on earlier versions
            }

        }
    }

    private func testNameAndPlace() {
        describe("PersonNameComponentsFormatter") {
            let formatter = PersonNameComponentsFormatter()

            var nameComponents = PersonNameComponents()
            nameComponents.givenName = "Johnny"
            nameComponents.familyName = "Appleseed"

            let str = formatter.string(from: nameComponents) // "Johnny Appleseed"
            print("English name: \(str)")
            nameComponents.givenName = "约翰尼"
            nameComponents.familyName = "苹果籽"
            let str1 = formatter.string(from: nameComponents) // "Johnny Appleseed"
            print("Chinese name: \(str1)")
        }
        describe("CNPostalAddressFormatter") {
            let address = CNMutablePostalAddress()
            address.street = "One Apple Park Way"
            address.city = "Cupertino"
            address.state = "CA"
            address.postalCode = "95014"

            let addressFormatter = CNPostalAddressFormatter()
            let addressStr = addressFormatter.string(from: address)
            /* "One Apple Park Way
             Cupertino CA 95014" */
            print("address str is \(addressStr)")
        }
    }

    private func testListFormatter() {
        if #available(iOS 13, *) {
            describe("list Formatter join") {
                let operatingSystems = ["macOS", "iOS", "iPadOS", "watchOS", "tvOS"]
                let str = ListFormatter.localizedString(byJoining: operatingSystems)
                print("joined str is \(str)")
            }
            describe("设置locale") {
                let operatingSystems = ["macOS", "iOS", "iPadOS", "watchOS", "tvOS"]
                let formatter = ListFormatter.init()
                formatter.locale = Locale.init(identifier: "zh_CN")
                let str = formatter.string(from: operatingSystems)
                print("joined str in chinese is \(str)")
            }
            describe("itemFormatter") {
                let numberFormatter = NumberFormatter()

                let listFormatter = ListFormatter()
                listFormatter.itemFormatter = numberFormatter
                print("什么都不做， 1 2 3 join")
                print(listFormatter.string(from: [1, 2, 3]))

                let 🇫🇷 = Locale(identifier: "fr_FR")
                listFormatter.locale = 🇫🇷

                numberFormatter.locale = 🇫🇷
                numberFormatter.numberStyle = .ordinal
                listFormatter.itemFormatter = numberFormatter
                print("设置itemFormatter， 1 2 3 join")
                print(listFormatter.string(from: [1, 2, 3]))
                // "1er, 2e et 3e"
            }
        }
    }
}
