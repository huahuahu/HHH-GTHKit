//
//  MirrorPlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/1/26.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest

class MirrorPlay: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let coordinate = ChessBoard.Coordinate.init(rank: 8, file: 2)
        let str = String.init(reflecting: coordinate)
        print(str)
    }

}

struct ChessBoard {
    typealias Rank = UInt8 // 行
    typealias File = UInt8 // 列

    struct Coordinate: Equatable, Hashable {
        private let value: UInt8

        var rank: Rank {
            return (value >> 3) + 1
        }

        var file: File {
            return (value & 0b00000111) + 1
        }

        init(rank: Rank, file: File) {
            precondition(1...8 ~= rank && 1...8 ~= file)
            self.value = ((rank - 1) << 3) + (file - 1)
        }
    }
}

extension ChessBoard.Coordinate: CustomReflectable {
    var customMirror: Mirror {
        return Mirror(self,
                      children: ["rank": rank, "file": file])
    }
}
