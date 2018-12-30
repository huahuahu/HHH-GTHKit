//
//  URLPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2018/12/31.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest

class URLPlay: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScheme() {
        var url = URL.init(string: "www.baidu.com")!
        XCTAssertNil(url.scheme, "scheme可以省略")
        url = URL.init(string: "http://www.baidu.com")!
        XCTAssertEqual(url.scheme, "http")
        url = URL.init(string: "HTTP://www.baidu.com")!
        XCTAssertEqual(url.scheme, "HTTP")

    }

    func testHostPort() {
        var url = URL.init(string: "http://www.baidu.com:80/3e")!
        XCTAssertEqual(url.host, "www.baidu.com", "域名host")
        XCTAssertEqual(url.port, 80, "port是80")

        url = URL.init(string: "http://www.baidu.com/3e")!
        XCTAssertNil(url.port, "没有显示指定port")

        url = URL.init(string: "http://192.32.33.2:80/3e")!
        XCTAssertEqual(url.host, "192.32.33.2", "ip host")
    }

    func testUserAndPassWord() {
        var url = URL.init(string: "ftp://ftp.prep.ai.mit.edu/pub/gnu")!
        XCTAssertNil(url.user)
        XCTAssertNil(url.password)

        url = URL.init(string: "ftp://anonymous@ftp.prep.ai.mit.edu/pub/gnu")!
        XCTAssertNotNil(url.user)
        XCTAssertNil(url.password, "没有指定密码")

        url = URL.init(string: "ftp://anonymous:my_passwd@ftp.prep.ai.mit.edu/pub/gnu")!
        XCTAssertEqual(url.user, "anonymous")
        XCTAssertEqual(url.password, "my_passwd")
    }

    func testPathAndParameters() {
        var url = URL.init(string: "http://www.baidu.com")!
        XCTAssertNotNil(url.path)
        XCTAssertTrue(url.pathComponents.isEmpty)

        url = URL.init(string: "http://www.joes-hardware.com:80/seasonal/index-fall.html")!
        XCTAssertEqual(url.pathComponents.count, 3, "第一个/也是一个pathComponent")
        XCTAssertTrue(url.path.hasPrefix("/"))

        url = URL.init(string: "ftp://prep.ai.mit.edu/pub/gnu;type=d")!
        XCTAssertEqual(url.lastPathComponent, "gnu", "pathComponent 不包括参数")
        //        If the URL contains a parameter string, it is appended to the path with a ;
        XCTAssertTrue(url.path.hasSuffix(";type=d"), "parameter被加在path后面，设计不合理")
        XCTAssertEqual(url.pathComponents.first!, "/", "第一个pathComponent是/")

        //两个path component 都有参数，URL API 处理的不好
        url = URL.init(string: "http://www.joes-hardware.com/hammers;sale=false/index.html;graphics=true")!
//        XCTAssertEqual(url.pathComponents.count, 3, "应该是3，苹果没有处理好")
    }

    func testQuery() {
        var url = URL.init(string: "http://www.joes-hardware.com/inventory-check.cgi?item=12731")!
        XCTAssertEqual(url.query, "item=12731", "单个query情况")

        url = URL.init(string: "http://www.joes-hardware.com/inventory-check.cgi?item=12731&color=blue")!
        XCTAssertEqual(url.query, "item=12731&color=blue", "多个query情况，&隔开")
    }

    func testFragment() {
        let url = URL.init(string: "http://www.joes-hardware.com/tools.html#drills")!
        XCTAssertEqual(url.fragment, "drills", "fragment不包括#")
    }

}
