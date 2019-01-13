//
//  CoreGraph.swift
//  DemoTests
//
//  Created by huahuahu on 2019/1/13.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
@testable import HHHKit

class CoreGraph: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSizeFit() {
        let center = CGPoint.init(x: 0.5, y: 0.5)
        let target = CGRect.init(origin: .zero, size: .init(width: 200, height: 100))
        let sizeToFit = CGSize.init(width: 1, height: 1)
        var fittedSize = sizeToFit.fit(into: target, alignment: center)
        XCTAssertEqual(fittedSize, .init(x: 50, y: 0, width: 100, height: 100))
        let topLeft = CGPoint.init(x: 0, y: 0)
        fittedSize = sizeToFit.fit(into: target, alignment: topLeft)
        XCTAssertEqual(fittedSize, .init(x: 0, y: 0, width: 100, height: 100))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
