//
//  KindsOfLocks.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/14.
//
//https://swifter.tips/lock/

import Foundation

/// 类似OC中的@synchronized
///
/// - Parameters:
///   - lock: 锁的唯一标识符
///   - closure: 要执行的代码，被加锁
public func synchronized(_ lock: AnyObject, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

