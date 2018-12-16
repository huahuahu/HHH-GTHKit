//
//  TestProtoclClass.swift
//  DemoTests
//
//  Created by huahuahu on 2018/12/16.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest
import Foundation

class TestProtoclClass: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // 测试可以拦截私有协议
    func testCanHandleCustom() {
        let exp = XCTestExpectation.init(description: "get fail")
        let config = URLSessionConfiguration.default
        config.protocolClasses = [CustomProtocol.self]
        URLSession.init(configuration: config).dataTask(with: URL.init(string: "custom://d")!) { (data, response, error) in
            if let customErr = error as? CustomError {
                print(customErr.failReason)
                exp.fulfill()
            } else {
            }
            }.resume()
        let result = XCTWaiter.wait(for: [exp], timeout: 3)
        XCTAssertTrue(result == .completed)
    }

    //测试可以拦截http协议
    func testCanHandleHttp() {
        let exp = XCTestExpectation.init(description: "get fail")
        let config = URLSessionConfiguration.default
        config.protocolClasses = [CustomProtocol.self]
        URLSession.init(configuration: config).dataTask(with: URL.init(string: "http://d")!) { (data, response, error) in
            if let customErr = error as? HttpError {
                print(customErr.failReason)
                exp.fulfill()
            } else {

            }
            }.resume()
        let result = XCTWaiter.wait(for: [exp], timeout: 3)
        XCTAssertTrue(result == .completed)
    }
}

struct CustomError: Error {
    let failReason = "custom scheme not imp"
}

struct HttpError: Error {
    let failReason = "http handled"
}

class CustomProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        if request.url?.scheme == "custom"  {
            return true
        } else if request.url?.scheme == "http" {
            return true
        } else {
            return false
        }
    }

    override func startLoading() {
        if self.request.url?.scheme == "custom" {
            self.client?.urlProtocol(self, didFailWithError: CustomError.init())
        } else if self.request.url?.scheme == "http" {
            self.client?.urlProtocol(self, didFailWithError: HttpError.init())
        }
    }

    override func stopLoading() {

    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

}
