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
//swiftlint:disable nesting
//swiftlint:disable identifier_name
//https://nshipster.com/propertywrapper/

class PropertyWrapperPlay: QuickSpec {
    override func spec() {
        testConstrainValue()
    }

    //test Constraining Values
    private func testConstrainValue() {
        it("限制") {
            var carbonicAcid = Solution(pH: 4.68) // at 1 mM under standard conditions
            carbonicAcid.pH = -9
            expect(carbonicAcid.pH).to(equal(0))
        }
    }
}

struct Solution {
    @Clamping(0...14) var pH: Double = 7.0
}

@propertyWrapper
struct Clamping<Value: Comparable> {
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
