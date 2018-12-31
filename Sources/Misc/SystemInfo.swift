//
//  SystemInfo.swift
//  HHHKit
//
//  Created by huahuahu on 2018/12/31.
//

import Foundation
#if os(Linux)
import Glibc
#else
import Darwin
#endif


/// 判断当前系统的端序
///
/// - Returns: `true`, 大端序; `false`, 小端序
public func isBigEndian() -> Bool {
    let raw: UInt64 = 0x12345678
    let bigEndianNumber = raw.bigEndian
    return raw == bigEndianNumber
    //等价于下面的
//    return CFByteOrderGetCurrent() == Int(CFByteOrderBigEndian.rawValue)
}
