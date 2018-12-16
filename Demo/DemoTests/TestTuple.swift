//
//  TestTuple.swift
//  DemoTests
//
//  Created by huahuahu on 2018/12/16.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest

class TestTuple: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNamedTuple() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let result = minMax(array: [1,2,3,4])
        print(result.min)
        print(result.max)
    }

    func minMax(array: [Int]) -> (min: Int, max: Int) {
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1..<array.count] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin, currentMax)
    }

}
