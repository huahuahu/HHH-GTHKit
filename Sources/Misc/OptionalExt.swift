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

public extension Optional where Wrapped: Collection {

    /// 如果非空，返回值；否则返回nil
    public var nonEmpty: Wrapped? {
        return self?.isEmpty == true ? nil : self
    }
}

public extension Optional {

    /// 判断是否为空，如果是空，抛出异常
    ///
    /// - Parameter err: 需要被抛出的异常
    /// - Returns: 如果不是nil，返回解包后的结果
    /// - Throws: 传入的异常
    func or(_ err: Error) throws -> Wrapped {
        guard let value = self else {
            throw err
        }
        return value
    }
}
