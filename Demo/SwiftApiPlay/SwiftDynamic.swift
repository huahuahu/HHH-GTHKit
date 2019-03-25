//
//  SwiftDynamic.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/2/24.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Quick
import Nimble

class SwiftDynamic: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class SwiftDynamicSpec: QuickSpec {
    override func spec() {
        //https://juejin.im/post/5b24c9896fb9a00e69608a71
        describe("dynamicMemberLookup 可以访问不存在的属性") {
            it("可以访问不存在的属性", closure: {
                //执行以下代码
                let person = Person()
                expect(person.city).to(equal("Hangzhou"))
                expect(person.nickname).to(equal("Zhuo"))
                expect(person.name).to(equal("undefined"))
                //必须声明返回值类型，否则编译不过
                let age: Int = person.age
                expect(age).to(equal(18))
            })
            it("可以继承！", closure: {
                let dev = Developer()
                expect(dev.ppp1).to(equal("user"))
                expect(dev.ppp2).to(equal("user"))
            })
        }
    }
}

@dynamicMemberLookup
struct Person {
    //如果实现了这个特性，你就不能返回可选值。必须处理好意料外的情况，一定要有值返回。不像常规的subscript方法可以返回可空的值。
    subscript(dynamicMember member: String) -> String {
        let properties = ["nickname": "Zhuo", "city": "Hangzhou"]
        return properties[member, default: "undefined"]
    }
    //可以被重载
    subscript(dynamicMember member: String) -> Int {
        return 18
    }
}

@dynamicMemberLookup
class User {
    subscript(dynamicMember member: String) -> String {
        return "user"
    }
}

//这个类也有动态查找的能力！
class Developer: User { }
