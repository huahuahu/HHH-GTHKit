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


/// 用于数据绑定的类
public final class Box<T> {
    public typealias Listenr = (T) -> Void

    /// 数据发生改变时，调用这个block
    public var listener: Listenr?

    private var observers: NSHashTable<AnyObject>
    private var managerKey: Void?

    /// 真正存储的值
    public var value: T {
        didSet {
            listener?(value)
            observers.allObjects.forEach { (observer) in
                let block = objc_getAssociatedObject(observer, &managerKey)
                if let block1 = block as? Listenr {
                    block1(value)
                }
            }
        }
    }

    /// 初始化方法
    ///
    /// - Parameter value: 用来被绑定的value
    public init(_ value: T) {
        self.value = value
        observers = NSHashTable<AnyObject>.weakObjects()
    }

    /// 添加数据绑定
    ///
    /// - Parameter listener: 数据变化时的响应。可以为nil
    public func bind(listener: Listenr?) {
        self.listener = listener
        listener?(value)
    }


    /// 添加观察者。target在销毁时，会自动移除观察，不会有内存泄漏。
    ///
    /// - Parameters:
    ///   - target: 观察者，变化时，会通知到它
    ///   - block: 发生变化时，需要执行的操作。block为nil，取消绑定
    public func bind(target: AnyObject, block: Listenr?) {
        observers.add(target)
        objc_setAssociatedObject(target, &managerKey, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        block?(value)
        if block == nil {
            observers.remove(target)
        }
    }
}

