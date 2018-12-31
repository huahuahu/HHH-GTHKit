//
//  String+HHH.swift
//  HHHKit
//
//  Created by huahuahu on 2018/12/31.
//

import Foundation

public extension String {

    /// string编码后的二进制数据，用字符串展示出来
    ///
    /// - Parameter encodingType: 字符串转二进制的编码方式
    /// - Returns: 编码后的二进制数据的字符串表示
    func asciiViewOf(encodingType: Encoding) -> String? {
        return self.data(using: encodingType)?.hexadecimal
    }
}

private extension Data {

    /// Data 的字符串表示形式
    var hexadecimal: String {
        //Data 遵守 Sequence 协议
        return map { String(format: "%02x", $0) }.joined(separator: "")
    }
}
