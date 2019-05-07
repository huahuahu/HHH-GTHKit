//
//  Regex.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/13.
//

extension NSRegularExpression {

    /// 根据静态字符串生成正则表达式
    ///
    /// - Parameter pattern: 静态字符串
    convenience init(_ pattern: StaticString) {
        do {
            try self.init(pattern: "\(pattern)")
        } catch {
            preconditionFailure("Illegal regex: \(pattern)")
        }
    }
}

extension String {

    /// 根据正则表达式切分字符串
    ///
    /// - Parameter pattern: 正则表达式
    /// - Returns: 切分后的字符串
    /// - Throws: 正则表达式不正确，会抛出异常
    func splitByRegex(_ pattern: String) throws -> [String] {
        let regex = try NSRegularExpression.init(pattern: pattern, options: [.anchorsMatchLines])
        let wholeRange = NSRange.init(startIndex..<endIndex, in: self)
        var allMatchedRange = regex.matches(in: self, options: [], range: wholeRange).map { $0.range }
        let endRange = NSRange.init(location: wholeRange.upperBound, length: 1)
        allMatchedRange.append(endRange)
        allMatchedRange.insert(NSRange.init(location: 0, length: 0), at: 0)

        var subStrs = [String]()
        zip(allMatchedRange.dropLast(), allMatchedRange.dropFirst()).forEach { (current, next) in
            let subRange = NSRange.init(location: current.location + current.length, length: next.location -  current.location - current.length)
            let strRange = Range.init(subRange, in: self)!
            let subStr =  self[strRange]
            subStrs.append(String(subStr))
        }
        return subStrs.filter { !$0.isEmpty }
    }
}


