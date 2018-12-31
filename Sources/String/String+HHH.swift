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


    /// 从Data 的字符串表示中，解码为字符串
    ///
    /// - Parameters:
    ///   - hexString: Data 的字符串表示
    ///   - encodingTye: 编码类型
    init?(hexString: String, encodingTye: Encoding) {
        let hexString = hexString.lowercased()
        let currentCharacterSet = CharacterSet.init(charactersIn: hexString)
        let validCharacterSet = CharacterSet.init(charactersIn: "0123456789abcdef")
        guard validCharacterSet.isSuperset(of: currentCharacterSet) else {
            print("\(hexString) contains invalid character")
            return nil
        }
        guard hexString.count % 2 == 0 else {
            print("\(hexString) must have even count")
            return nil
        }
        var data = Data()
        var currentIndex = hexString.startIndex
        while currentIndex < hexString.endIndex {
            let nextIndex = hexString.index(currentIndex, offsetBy: 2)
            let subStr = hexString[currentIndex..<nextIndex]
            let nextInt = UInt8.init(subStr, radix:16)!
            data.append(nextInt)
            currentIndex = nextIndex
        }
        self.init(data: data, encoding: encodingTye)
    }
}

private extension Data {

    /// Data 的字符串表示形式
    var hexadecimal: String {
        //Data 遵守 Sequence 协议
        return map { String(format: "%02x", $0) }.joined(separator: "")
    }
}
