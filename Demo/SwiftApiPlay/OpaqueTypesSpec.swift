//
//  SomeSpec.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/6/15.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Quick
import Nimble

//https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html
// hide type information
// opaque types preserve type identity—the compiler has access to the type information, but clients of the module don’t
class SomeSpec: QuickSpec {
    override func spec() {
        it("some 作为修饰符") {
            guard #available(iOS 13, *) else {
                return
            }
            func makeInt() -> some Equatable {
                return 5
            }

            let intA = makeInt()
            let intB = makeInt()
            expect((intA as? Int) == 5).to(beTrue())
            expect((intB as? Int) == 5).to(beTrue())
            if intA == intB {
                print("equal")
            }

        }
    }
}
