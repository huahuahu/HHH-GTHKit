//
//  String+encrypt.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/20.
//

import Foundation
import CommonCrypto

extension String {

    /// 对字符串MD5加密
    ///
    /// - Returns: 字符串md5 之后的结果
    func md5() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return digest.reduce("") { $0 + String.init(format: "%02x", $1) }
    }

    /// 对字符串 sha1 加密
    ///
    /// - Returns: 字符串 sha1 之后的结果
    func sha1() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))

        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_SHA1(body, CC_LONG(d.count), &digest)
            }
        }
        return digest.reduce("") { $0 + String.init(format: "%02x", $1) }
    }
}
