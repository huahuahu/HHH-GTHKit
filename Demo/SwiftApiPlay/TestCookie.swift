//
//  TestCookie.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/19.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Foundation

class TestCookie: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDomain() {
        //https://stackoverflow.com/questions/31311576/what-is-the-default-cookieacceptpolicy?rq=1
        // 似乎自己的cookieStorage 不能改变 AcceptPolicy
        var cookieStorage = HTTPCookieStorage.init()
        XCTAssertEqual(cookieStorage.cookieAcceptPolicy, .onlyFromMainDocumentDomain, "默认值")
        cookieStorage.cookieAcceptPolicy = .always
        XCTAssertEqual(cookieStorage.cookieAcceptPolicy, .onlyFromMainDocumentDomain, "修改无效")

        // 所以还是用shared的吧
        cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .always
        XCTAssertEqual(cookieStorage.cookieAcceptPolicy, .always, "修改后生效了")

        cookieStorage.removeCookies(since: Date.distantPast)
        XCTAssertEqual(cookieStorage.cookies?.count ?? 0, 0, "清空cookie")
        //种在 baidu.com ，前面没有.
        var url = URL.init(string: "http://baidu.com")!
        if let cookie = url.cookie(value: "sessionValue", forName: "session") {
            cookieStorage.setCookie(cookie)
        }
        XCTAssertEqual(cookieStorage.cookies!.count, 1, "种了一个cookie")
        var testUrl = URL.init(string: "http://a.baidu.com")!
        var cookieGot = cookieStorage.cookies(for: testUrl)
        XCTAssertEqual(cookieGot?.count ?? 0, 0, "a.baidu.com 接受不到 baidu.com 的cookie")

        testUrl = URL.init(string: "http://baidu.com")!
        cookieGot = cookieStorage.cookies(for: testUrl)
        XCTAssertEqual(cookieGot?.count ?? 1, 1, "baidu.com 可以接收到 baidu.com 的cookie")

        cookieStorage.removeCookies(since: Date.distantPast)
        XCTAssertEqual(cookieStorage.cookies?.count ?? 0, 0, "清空cookie")
        //种在 .baidu.com ，前面有.
        url = URL.init(string: "http://.baidu.com")!
        if let cookie = url.cookie(value: "sessionValue", forName: "session") {
            cookieStorage.setCookie(cookie)
        }
        XCTAssertEqual(cookieStorage.cookies!.count, 1, "种了一个cookie")
        testUrl = URL.init(string: "http://a.baidu.com")!
        cookieGot = cookieStorage.cookies(for: testUrl)
        XCTAssertEqual(cookieGot?.count ?? 0, 1, "a.baidu.com 接受到 .baidu.com 的cookie")

        testUrl = URL.init(string: "http://baidu.com")!
        cookieGot = cookieStorage.cookies(for: testUrl)
        XCTAssertEqual(cookieGot?.count ?? 1, 1, "baidu.com 可以接收到 .baidu.com 的cookie")
    }
}

extension URL {
    public func cookiePreperties(value: String, forName name: String) -> [HTTPCookiePropertyKey: Any] {
        var properties: [HTTPCookiePropertyKey: Any] = [
            .name: name,
            .value: value,
            .path: "/", //self.path,
            .expires: Date(timeIntervalSinceNow: 24 * 60 * 60),
            .originURL: self,
            .version: "0"
            ] as [HTTPCookiePropertyKey: Any]
        if let host = self.host { properties[.domain] = host }
        return properties
    }
    public func cookie(value: String, forName name: String) -> HTTPCookie? {
        let properties = self.cookiePreperties(value: value, forName: name)
        return HTTPCookie(properties: properties)
    }
}
