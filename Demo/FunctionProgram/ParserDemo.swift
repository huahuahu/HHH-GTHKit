//
//  Parser.swift
//  FunctionProgram
//
//  Created by huahuahu on 2019/1/13.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest

class ParserTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSequenceParser() {
        let one = character(matching: { $0 == "1"})
        guard let (result, string) = one.parser("123") else { return }
        XCTAssertEqual(result, "1")
        XCTAssertEqual(string, "23")
        let digit = character(matching: { CharacterSet.decimalDigits.contains($0) })
        guard let (result1, string1) =  digit.parser("123") else { return }
        XCTAssertEqual(result1, "1")
        XCTAssertEqual(string1, "23")
        guard let rr0 = digit.many.parser("123") else { return }
        XCTAssertEqual(rr0.result, ["1", "2", "3"])
        XCTAssertEqual(rr0.remainder, "")

        let intergerParser = digit.many.map { Int(String($0))! }
        let rr1 = intergerParser.parser("123jfa")!
        XCTAssertEqual(rr1.result, 123)
        XCTAssertEqual(rr1.remainder, "jfa")

    }

    func testMultiParser() {
        let digit = character(matching: { CharacterSet.decimalDigits.contains($0) })
        let intergerParser = digit.many.map { Int(String($0))! }

        let multiply = intergerParser.followed(by: character {$0 == "*"}).followed(by: intergerParser)
        let multiply1 = multiply.map { $0.0 * $1}
        let result = multiply1.parser("2*4")
        XCTAssertEqual(result?.result, 8)
    }

}

extension CharacterSet {
    func contains(_ char: Character) -> Bool {
        let scalars = String.init(char).unicodeScalars
        guard scalars.count == 1 else { return false }
        return contains(scalars.first!)
    }
}

struct Parser<Result> {
    let parser: (String) -> (result: Result, remainder: String)?
}

func character(matching conditions: @escaping (Character) -> Bool) -> Parser<Character> {
    return Parser.init(parser: { (input) in
        guard let char = input.first, conditions(char) else { return nil }
        return (char, String(input.dropFirst()))
    })
}

extension Parser {
    var many: Parser<[Result]> {
        return Parser<[Result]> {
            input in
            var result = [Result]()
            var remainder = input
            while let (element, newRemainder) = self.parser(remainder) {
                result.append(element)
                remainder = newRemainder
            }
            return (result, remainder)
        }
    }

    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T> {
        return Parser<T> {
            input in
            guard let (result, remainder) = self.parser(input) else { return nil }
            return (transform(result), remainder)
        }
    }

    /// 接受另一个解析器为参数，返回一个全新的解析器。把前两个解析器的结果组合为一个元组返回. 这个太复杂，不要用这个  
    ///
    /// - Parameter other: 另一个解析器
    /// - Returns: 返回的解析器
    func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
        return Parser<(Result, A)> {
            input in
            guard let (result1, remainder1) = self.parser(input) else { return nil }
            guard let (result2, remainder2) = other.parser(remainder1) else { return nil }
            return ((result1, result2), remainder2)
        }
    }
}
