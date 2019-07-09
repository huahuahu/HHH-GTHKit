//
//  PropertyWrapperPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/7/3.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Foundation

//swiftlint:disable identifier_name
//https://nshipster.com/propertywrapper/

class PropertyWrapperPlay: QuickSpec {
    override func spec() {
        testConstrainValue()
        testTransvarformingValues()
        testSynthesizedEquality()
        testAuditingPropertyAccess()
    }

    //test Constraining Values
    private func testConstrainValue() {
        it("限制") {
            var carbonicAcid = Solution(pH: 4.68)
            expect(carbonicAcid.pH).to(equal(4.68))
            carbonicAcid.pH = -9
            expect(carbonicAcid.pH).to(equal(0))
        }
        it("限制可以组合") {
            var cornflowerBlue = RGB(red: 0.392, green: 0.584, blue: 0.929)
            expect(cornflowerBlue.red).to(equal(0.392))
            expect(cornflowerBlue.green).to(equal(0.584))
            expect(cornflowerBlue.blue).to(equal(0.929))
            cornflowerBlue.blue = 9
            expect(cornflowerBlue.blue).to(equal(1))
        }
    }

//    Transforming Values on Property Assignment
    private func testTransvarformingValues() {
        it("可以自动变换") {
            //初始化时
            var quine = Post(title: "  Swift Property Wrappers  ", body: "...")
            expect(quine.title).to(equal("Swift Property Wrappers"))
            //后续赋值时
            quine.title = "      @propertyWrapper     "
            expect(quine.title).to(equal("@propertyWrapper"))
        }
    }

//    Synthesized Equality
    private func testSynthesizedEquality() {
        it("比较可以不管大小写") {
            let hello: String = "hello"
            let HELLO: String = "HELLO"
            expect(hello == HELLO).notTo(beTrue())

            expect(CaseInsensitive(wrappedValue: hello) == CaseInsensitive(wrappedValue: HELLO)).to(beTrue())
        }
        it("可以作为属性") {
            let johnny = Account(name: "johnny")
            let JOHNNY = Account(name: "JOHNNY")
            let Jane = Account(name: "Jane")
            expect(johnny == JOHNNY).to(beTrue())
            expect(johnny == Jane).notTo(beTrue())
            expect(johnny.name1 == JOHNNY.name1).notTo(beTrue())
        }
    }

    private func testAuditingPropertyAccess() {
        it("可以记录历史轨迹") {
            let report = ExpenseReport.init()
            self.wait(0.5)
            report.state = .denied
            self.wait(1.5)
            report.state = .received
            self.wait(2.5)
            report.state = .submitted
            report.printHistory()
        }
    }

    private func wait(_ seconds: Double) {
        waitUntil(timeout: seconds + 2) { (done) in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds) {
                done()
            }
        }
    }
}

private struct Solution {
    @Clamping(0...14) var pH: Double = 7.0
}

@propertyWrapper
private struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    var wrappedValue: Value {
        get {
            value
        }
        set {
            value = min(max(range.lowerBound, newValue), range.upperBound)
        }
    }
}

@propertyWrapper
private struct UnitInterval<Value: FloatingPoint> {
    @Clamping(0...1) var wrappedValue: Value = .zero

    init(initialValue value: Value) {
        self.wrappedValue = value
    }
}

private struct RGB {
    @UnitInterval var red: Double
    @UnitInterval var green: Double
    @UnitInterval var blue: Double
}

//during initialization or via property access afterward — automatically has its leading or trailing whitespace removed
@propertyWrapper
private struct Trimmed {
    private(set) var value: String = ""

    var wrappedValue: String {
        get { value }
        set {
            value = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    init(initialValue: String) {
        self.wrappedValue = initialValue
    }
}

private struct Post {
    @Trimmed var title: String
    @Trimmed var body: String
}

@propertyWrapper
private struct CaseInsensitive<Value: StringProtocol> {
    var wrappedValue: Value
}

extension CaseInsensitive: Comparable {
    private func compare(_ other: CaseInsensitive) -> ComparisonResult {
        wrappedValue.caseInsensitiveCompare(other.wrappedValue)
    }

    static func == (lhs: CaseInsensitive, rhs: CaseInsensitive) -> Bool {
        lhs.compare(rhs) == .orderedSame
    }

    static func < (lhs: CaseInsensitive, rhs: CaseInsensitive) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }

    static func > (lhs: CaseInsensitive, rhs: CaseInsensitive) -> Bool {
        lhs.compare(rhs) == .orderedDescending
    }
}

private struct Account: Equatable {
    @CaseInsensitive var name1: String

    init(name: String) {

//        name1 = name
        $name1 = CaseInsensitive(wrappedValue: name)
    }
}

@propertyWrapper
private struct Versioned<Value> {
    private var value: Value
    private(set) var timestampedValues: [(Date, Value)] = []

    var wrappedValue: Value {
        get { value }

        set {
            defer { timestampedValues.append((Date(), value)) }
            value = newValue
        }
    }

    init(initialValue value: Value) {
        self.value = value
        wrappedValue = value
    }
}

private class ExpenseReport {
    enum State { case submitted, received, approved, denied }

    @Versioned var state: State = .submitted

    func printHistory() {
        print("printHistory start")
        $state.timestampedValues.forEach { (record) in
            print(record)
        }
        print("printHistory end")
    }
}
