//
//  CollectionExtension.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/6.
//

import Foundation

extension Sequence {

    /// 每一个元素运行一次闭包，返回自己
    ///
    /// - Parameter body: 闭包
    /// - Returns: 自身
    /// - Throws: 闭包里的异常
    @discardableResult
    public func forEachPerform(_ body: (Element) throws -> ()) rethrows -> Self {
        try forEach(body)
        return self
    }


    /// 自己作为参数，执行body里的操作
    ///
    /// - Parameter body: 闭包，参数是自己
    /// - Returns: 自己
    /// - Throws: 闭包里的异常
    @discardableResult
    public func perform(_ body: (Self) throws -> ()) rethrows -> Self {
        try body(self)
        return self
    }

}
