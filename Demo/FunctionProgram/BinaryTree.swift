//
//  BinaryTree.swift
//  FunctionProgram
//
//  Created by huahuahu on 2019/1/12.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest

class BinaryTree: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // 空的
//        let leaf: BinarySearchTree<Int> = .leaf
        // 左子树，自己，右子树
//        let five: BinarySearchTree<Int> = .node(leaf, 5, leaf)
//        let fiveSame: BinarySearchTree<Int> = .init(5)

    }

}

//swiftlint:disable identifier_name
/// 二叉查找树
///
/// - leaf: 或者是叶子结点
/// - node: 或者是一个有三个关联值的结点node。分别是左子树，自己，右子树
indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

extension BinarySearchTree {
    init() {
        self = .leaf
    }

    init(_ value: Element) {
        self = .node(.leaf, value, .leaf)
    }
}

extension BinarySearchTree {

    /// 含有元素的个数
    var count: Int {
        switch self {
        case .leaf:
            return 0
        case let .node(left, _, right):
            return 1 + left.count + right.count
        }
    }
}

extension BinarySearchTree {

    /// 包含的所有元素
    var elements: [Element] {
        switch self {
        case .leaf:
            return []
        case let .node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
}

extension BinarySearchTree {
    func reduce<A>(leaf leafF: A, node nodeF: (A, Element, A) -> A) -> A {
        switch self {
        case .leaf:
            return leafF
        case let .node(left, x, right):
            return nodeF(left.reduce(leaf: leafF, node: nodeF),
                        x,
                        right.reduce(leaf: leafF, node: nodeF))
        }
    }
}

extension BinarySearchTree {

    /// 和element一样，不过使用了reduce方法
    var elementR: [Element] {
        //这里，$0 和  $1 都是数组类型
        return reduce(leaf: []) { $0 + [$1] + $2 }
    }

    /// 和count 一样，不过用了reduce方法
    var countR: Int {
//        reduce(leaf: 0) { (left, x, right) -> Int in
//            return left + 1 + right
//        }
        // 这里 $0 和 $1 都是Int类型
        return reduce(leaf: 0) { $0 + 1 + $2}
    }
}

extension BinarySearchTree {
    var isEmpty: Bool {
        if case .leaf = self {
            return true
        }
        return false
    }
}

extension BinarySearchTree {
    var isBST: Bool {
        switch self {
        case .leaf:
            return true
        case let .node(left, x, right):
            return left.elements.allSatisfy { $0 < x}
                && right.elements.allSatisfy { $0 > x}
                && left.isBST
                && right.isBST
        }
    }
}

extension BinarySearchTree {
    func contains(_ x: Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case let .node(_, y, _) where x == y:
            return true
        case let .node(left, y, _) where x < y:
            return left.contains(x)
        case let .node(_, y, right) where x > y:
            return right.contains(x)
        default:
            fatalError("impossible occurred")
        }
    }
}

extension BinarySearchTree {
    mutating func insert(_ x: Element) {
        switch self {
        case .leaf:
            self = BinarySearchTree.init(x)
        case .node(var left, let y, var right):
            if x < y { left.insert(x) }
            if x > y { right.insert(x) }
            self = .node(left, y, right)
        }
    }
}
