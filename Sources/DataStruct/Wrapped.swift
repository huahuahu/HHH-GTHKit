//
//  Wrapped.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/10.
//

import Foundation

/// 简单的线程安全的变量
public final class Atomic<A> {

    /// 串行队列，用来防止crash
    private let queue = DispatchQueue.init(label: "Atomic Serial Queue")
    private var _value: A
    
    public init(_ value: A) {
        _value = value
    }

    /// 读取值，线程安全；设置值，不安全
    public var value: A {
        get {
            return queue.sync { self._value }
        }
        // 这么做有缺陷，可能读取不一致
        set {
            queue.sync { self._value = newValue }
        }
    }

    /// 线程安全的改变方法
    ///
    /// - Parameter transform: 对A采取的变换，可以改变value 的值
    public func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
