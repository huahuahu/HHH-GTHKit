//
//  TypeErase.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/4/4.
//  Copyright © 2019 huahuahu. All rights reserved.
//
//https://www.mikeash.com/pyblog/friday-qa-2017-12-08-type-erasure-in-swift.html

import Foundation
import XCTest
import Quick
import Nimble

//swiftlint:disable nesting
enum TypeErase {

    class MAnySequence<Element>: Sequence {
        class Iterator: IteratorProtocol {
            func next() -> Element? {
                fatalError("Must override next()")
            }
        }
        func makeIterator() -> Iterator {
            fatalError("Must override makeIterator()")
        }
    }

    private class MAnySequenceImpl<Seq: Sequence>: MAnySequence<Seq.Element> {
        class IteratorImpl: Iterator {
            var wrapped: Seq.Iterator

            init(_ wrapped: Seq.Iterator) {
                self.wrapped = wrapped
            }
            override func next() -> Seq.Element? {
                return wrapped.next()
            }
        }
        var seq: Seq

        init(_ seq: Seq) {
            self.seq = seq
        }
        override func makeIterator() -> IteratorImpl {
            return IteratorImpl(seq.makeIterator())
        }
    }

}

extension TypeErase.MAnySequence {
    static func make<Seq: Sequence>(_ seq: Seq) -> TypeErase.MAnySequence<Element> where Seq.Element == Element {
        return TypeErase.MAnySequenceImpl<Seq>(seq)
    }
}

//swiftlint:disable identifier_name
enum TypeEraseFunction {
    struct MAnySequence<Element>: Sequence {
        struct Iterator: IteratorProtocol {
            let _next: () -> Element?

            func next() -> Element? {
                return _next()
            }
        }

        let _makeIterator: () -> Iterator

        func makeIterator() -> Iterator {
            return _makeIterator()
        }
        init<Seq: Sequence>(_ seq: Seq) where Seq.Element == Element {
            _makeIterator = {
                var iterator = seq.makeIterator()
                return Iterator(_next: { iterator.next() })
            }
        }
    }

    class GenericDataSource<Element> {
        let count: () -> Int
        let getElement: (Int) -> Element

        init<C: Collection>(_ c: C) where C.Element == Element, C.Index == Int {
            count = { c.count }
            getElement = { c[$0 - c.startIndex] }
        }
    }
}

class TypeEraseSpec: QuickSpec {
    override func spec() {
        describe("typeErase OK") {
            func printInts(_ seq: TypeErase.MAnySequence<Int>) {
                for elt in seq {
                    print(elt)
                }
            }

            let array = [1, 2, 3, 4, 5]
            printInts(TypeErase.MAnySequence.make(array))
            printInts(TypeErase.MAnySequence.make(array[1 ..< 4]))
        }

        describe("typeErase function ok") {
            func printInts(_ seq: TypeEraseFunction.MAnySequence<Int>) {
                for elt in seq {
                    print(elt)
                }
            }

            let array = [1, 2, 3, 4, 5]
            printInts(TypeEraseFunction.MAnySequence(array))
            printInts(TypeEraseFunction.MAnySequence(array[1 ..< 4]))
        }
    }
}
