//
//  OptionalExt.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/7.
//

import Foundation


// MARK: - bool 的 Option 的扩展
public extension Optional where Wrapped == Bool {

    /// 如果不是nil，返回对应的值；否则返回false
    public var orFalse: Bool {
        if let b = self {
            return b
        } else {
            return false
        }
    }

    /// 如果不是nil，返回对应的值；否则返回true
    public var orTrue: Bool {
        if let b = self {
            return b
        } else {
            return true
        }
    }
}
