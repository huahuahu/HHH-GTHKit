//
//  Trie.swift
//  FunctionProgram
//
//  Created by huahuahu on 2019/1/12.
//  Copyright © 2019 huahuahu. All rights reserved.
//
// 字典树，自动补全
import XCTest

class TrieTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let conents = ["cat", "car", "cart", "dog"]
        let trieOfWords = Trie<Character>.build(words: conents)
        let result = "car".complete(trieOfWords)
        print(result)
        XCTAssertEqual(result, ["car", "cart"])
    }

}

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Element: Trie<Element>]
}

extension Trie {
    //空的字典树
    init() {
        isElement = false
        children = [:]
    }

    init(_ key: ArraySlice<Element>) {
        if let (head, tail) = key.decomposed {
            let children = [head: Trie.init(tail)]
            self = Trie.init(isElement: false, children: children)
        } else {
            self = Trie.init(isElement: true, children: [:])
        }
    }
}

extension Trie {
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            // 很精妙的实现
            result += value.elements.map { [key] + $0 }
        }
        return result
    }
}

extension Array {
    var slice: ArraySlice<Element> {
        return ArraySlice.init(self)
    }
}

extension ArraySlice {
    var decomposed: (Element, ArraySlice<Element>)? {
        return isEmpty ? nil : (self[startIndex], self.dropFirst())
    }
}

extension Trie {
    func lookup(key: ArraySlice<Element>) -> Trie<Element>? {
        guard let (head, tail) = key.decomposed else { return self }
        guard let subTrie = children[head] else {
            return nil
        }
        return subTrie.lookup(key: tail)
    }
}

extension Trie {
    func complete(key: ArraySlice<Element>) -> [[Element]] {
        return lookup(key: key)?.elements ?? []
    }
}

extension Trie {
    func inserting(_ key: ArraySlice<Element>) -> Trie<Element> {
        guard let (head, tail) = key.decomposed else {
            return Trie.init(isElement: true, children: children)
        }
        var newChildren = children
        if let nextTrie = children[head] {
            newChildren[head] = nextTrie.inserting(tail)
        } else {
            newChildren[head] = Trie(tail)
        }
        return Trie.init(isElement: isElement, children: newChildren)
    }
}

extension Trie {
    static func build(words: [String]) -> Trie<Character> {
        let emptyTrie = Trie<Character>()
        return words.reduce(emptyTrie) { (trie, word) in
            trie.inserting(word.map{ $0 }.slice)
        }
    }
}

extension String {
    func complete(_ knownWords: Trie<Character>) -> [String] {
        let chars = self.map { $0 }.slice
        let completed = knownWords.complete(key: chars)
        return completed.map({ (chars) in
            self + String.init(chars)
        })
    }
}
