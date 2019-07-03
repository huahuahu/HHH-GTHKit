//
//  URLPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2018/12/31.
//  Copyright © 2018 huahuahu. All rights reserved.
//

import XCTest
import HHHKit

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
        url = URL.init(string: "http://www.baidu.com/")!
        XCTAssertEqual(url.path, "/", "/也是路径的一部分")
        XCTAssertEqual(url.pathComponents.count, 1, "只有一个path component，就是 /")

        url = URL.init(string: "http://www.baidu.com/aa")!
        url = URL.init(string: "http://www.baidu.com/aa/")!
        XCTAssertEqual(url.path, "/aa", "")
        XCTAssertEqual(url.path, "/aa", "path 不包括最后的斜线")

        url = URL.init(string: "http://www.joes-hardware.com:80/seasonal/index-fall.html")!
        XCTAssertEqual(url.pathComponents.count, 3, "第一个/也是一个pathComponent")
        XCTAssertTrue(url.path.hasPrefix("/"))

        url = URL.init(string: "ftp://prep.ai.mit.edu/pub/gnu;type=d")!
        XCTAssertEqual(url.lastPathComponent, "gnu;type=d", "pathComponent 不包括参数")
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

    func testUrlComponents() {
        var urlComponent = URLComponents.init(string: "http://www.baidu.com/df")!

        urlComponent.fragment = "发达"
        XCTAssertEqual(urlComponent.percentEncodedFragment!, "%E5%8F%91%E8%BE%BE", "%编码后的片段")
        //新的 -> %e6%96%b0%e7%9a%84
        urlComponent.percentEncodedFragment = "%e6%96%b0%e7%9a%84"
        XCTAssertEqual(urlComponent.fragment!, "新的", "设置%编码过后，会自动更新对应的值")
        // 会crash，因为不是正确的编码后结果
//        urlComponent.percentEncodedFragment = "%e6%96%b0%e7%9a%%%4"

        urlComponent = URLComponents.init(string: "http://www.baidu.com/df")!
        XCTAssertEqual(urlComponent.path, "/df", "/及以后")
        urlComponent = URLComponents.init(string: "http://www.baidu.com/df/")!
        XCTAssertEqual(urlComponent.path, "/df/", "/及以后，即使以/结尾")
        urlComponent = URLComponents.init(string: "http://www.baidu.com/df?d=9")!
        XCTAssertEqual(urlComponent.path, "/df", "/及以后，不包括?")
        urlComponent = URLComponents.init(string: "http://www.baidu.com/df/?d=9")!
        XCTAssertEqual(urlComponent.path, "/df/", "/及以后，不包括?,但是包括?之前的/")

        //query d=9&新的=大  新的 ->%e6%96%b0%e7%9a%84 大-> %e5%a4%a7
        urlComponent = URLComponents.init(string: "http://www.baidu.com/df/?d=9")!
        XCTAssertEqual(urlComponent.query, "d=9")
        urlComponent = URLComponents.init(string: "http://www.baidu.com/df/?d=9#d")!
        XCTAssertEqual(urlComponent.query, "d=9")

        //新的 %-> %e6%96%b0%e7%9a%84
        //大 %-> %e5%a4%a7
        //新的=大 -> %e6%96%b0%e7%9a%84=%e5%a4%a7
        urlComponent = URLComponents.init(string: "http://www.baidu.com/df/?d=9&%e6%96%b0%e7%9a%84=%e5%a4%a7#d")!
        XCTAssertEqual(urlComponent.query, "d=9&新的=大", "最标准的编解码方法，每个key/value分别编码")
        XCTAssertEqual(urlComponent.queryItems!.count, 2, "url里有一个&，因此有两个item")
        XCTAssertEqual(urlComponent.queryItems!.first!.name, "d", "第一个item name是d")
        XCTAssertEqual(urlComponent.queryItems!.first!.value, "9", "第一个item value是9")
        XCTAssertEqual(urlComponent.queryItems!.last!.name, "新的", "第二个item name是 新的 ")
        XCTAssertEqual(urlComponent.queryItems!.last!.value, "大", "第二个item value是 大 ")

        //d=9&新的=大 %-> d%3d9%26%e6%96%b0%e7%9a%84%3d%e5%a4%a7
        urlComponent = URLComponents.init(string: "http://www.baidu.com/df/?d%3d9%26%e6%96%b0%e7%9a%84%3d%e5%a4%a7#d")!
        XCTAssertEqual(urlComponent.query, "d=9&新的=大", "也可以把原始的query直接%编码")
        XCTAssertEqual(urlComponent.queryItems!.count, 1, "url里有一个&都没有，因此只有一个item")
//        XCTAssertEqual(urlComponent.queryItems!.first!.name, 1, "url里有一个&都没有，因此只有一个item")

        urlComponent = URLComponents.init(string: "http://www.baidu.com/df/?d=9&d=8&d=8")!
        XCTAssertEqual(urlComponent.queryItems!.count, 3, "有重复的key/value，通通加上去")

    }
}
