//
//  Numbers.swift
//  HHHKit
//
//  Created by huahuahu on 2018/12/31.
//

import Foundation

/// 不同端序在内存中表示时，用字符串怎么表示,地址从低到高
///   - 0x01020304
///   - 大端序: 01020304
///   - 小端序: 04030201
public protocol HexRespresentation {

    /// 大端序的表达
    var bigEndianHex: String { get }

    /// 小端序的表达
    var littleEndianHex: String { get }
}

extension UInt16: HexRespresentation {
    public var bigEndianHex: String {
        return String.init(format: "%04x", self)
    }

    public var littleEndianHex: String {
        let reversed = isBigEndian() ? self.littleEndian : self.bigEndian
        return String.init(format: "%04x", reversed)
    }

}

extension UInt32: HexRespresentation {
    public var bigEndianHex: String {
        return String.init(format: "%08x", self)

    }

    public var littleEndianHex: String {
        let reversed = isBigEndian() ? self.littleEndian : self.bigEndian
        return String.init(format: "%08x", reversed)
    }
}

extension UInt8: HexRespresentation {
    public var bigEndianHex: String {
        return String.init(format: "%02x", self)
    }

    public var littleEndianHex: String {
        return bigEndianHex
    }
}
