//
//  Basic.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/7/3.
//  Copyright © 2019 huahuahu. All rights reserved.
//
import Foundation
import XCTest
import Quick
import Nimble

class BasicSpec: QuickSpec {
    override func spec() {
        testDictNil()
    }

    private func testDictNil() {
        it("值可以为 nil 的字典") {
            var dictWithNils: [String: Int?] = [
                "one": 1,
                "two": 2,
                "none": nil
            ]
            dictWithNils["two"] = nil
            dictWithNils["one"] = nil
            let result = dictWithNils.count
            expect(result).to(equal(1))
        }
    }
}
