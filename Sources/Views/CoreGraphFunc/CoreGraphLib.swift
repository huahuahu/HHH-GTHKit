//
//  CoreGraphLib.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/12.
//
// 一个小型的画图库

import Foundation


/// 支持的图形
///
/// - ellipse: 椭圆
/// - rectangle: 矩形
/// - text: 文字
public enum Primitive {
    case ellipse
    case rectangle
    case text(String)
}


/// 支持的定制化
///
/// - fillColor: 用颜色填充
public enum Attribute {
    case fillColor(UIColor)
}

/// 图表的枚举
///
/// - primitive: 有确定尺寸的Primitive
/// - beside: 一对左右相邻的图表
/// - below: 一对上下相邻的图表
/// - attribute: 定制的图表样式
/// - align: 对齐方式
indirect public enum Diagram {
    case primitive(CGSize, Primitive)
    case beside(Diagram, Diagram)
    case below(Diagram, Diagram)
    case attributed(Attribute, Diagram)
    case align(CGPoint, Diagram)
}

public extension Diagram {
    fileprivate var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
        case .attributed(_, let x):
            return x.size
        case let .beside(l, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize.init(width: sizeL.width + sizeR.width, height: max(sizeL.height, sizeR.height))
        case let .below(u, d):
            return CGSize.init(width: max(u.size.width, d.size.width), height: u.size.height + d.size.height)
        case .align(_, let r):
            return r.size
        }
    }

    static func rect(width: CGFloat, height: CGFloat) -> Diagram {
        return .primitive(CGSize.init(width: width, height: height), .rectangle)
    }

    static func circle(diameter: CGFloat) -> Diagram {
        return .primitive(CGSize.init(width: diameter, height: diameter), .ellipse)
    }

    static func text(_ theText: String, width: CGFloat, height: CGFloat) -> Diagram {
        return .primitive(CGSize.init(width: width, height: height), .text(theText))
    }

    static func square(side: CGFloat) -> Diagram {
        return rect(width: side, height: side)
    }
}

public extension Diagram {
    func filled(_ color: UIColor) -> Diagram {
        return .attributed(.fillColor(color), self)
    }
    func aligned(to position: CGPoint) -> Diagram {
        return .align(position, self)
    }
}

extension Diagram {
    init() {
        self = Diagram.rect(width: 0, height: 0)
    }
}
public extension Sequence where Iterator.Element == Diagram {
    public var hcat: Diagram {
        return reduce(Diagram(), |||)
    }
}

precedencegroup HorizontalCombination {
    higherThan: VerticalCombination
    associativity: left
}

infix operator |||: HorizontalCombination
public func |||(l: Diagram, r:Diagram) -> Diagram {
    return .beside(l, r)
}

precedencegroup VerticalCombination {
    associativity: left
}
infix operator --- : VerticalCombination
public func ---(l: Diagram, r: Diagram) -> Diagram {
    return .below(l, r)
}

extension CGSize {
    static func *(l: CGFloat, r: CGSize) -> CGSize {
        return CGSize.init(width: r.width * l, height: r.height * l)
    }

    static func *(l: CGSize, r: CGSize) -> CGSize {
        return CGSize.init(width: l.width * r.width, height: l.height * r.height)
    }

    static func -(l: CGSize, r: CGSize) -> CGSize {
        return CGSize.init(width: l.width - r.width, height: l.height - r.height)
    }

    var point: CGPoint {
        return CGPoint.init(x: width, y: height)
    }


    /// 尺寸在长宽比不变的情况下，根据传入的矩形进行缩放
    ///
    /// - Parameters:
    ///   - rect: 传入的矩形
    ///   - alignment: 等比缩放后的矩形在目标矩形中的位置
    /// - Returns: 缩放后的矩形
    func fit(into rect: CGRect, alignment: CGPoint) -> CGRect {
        let scale = min(rect.width / width, rect.height / height)
        let targetSize = scale * self
        let spaceSize = alignment.size * (rect.size - targetSize)
        return CGRect.init(origin: rect.origin + spaceSize.point, size: targetSize)
    }

}

public extension CGPoint {
    static func +(l: CGPoint, r: CGPoint) -> CGPoint {
        return CGPoint.init(x: l.x + r.x, y: l.y + r.y)
    }

    var size: CGSize {
        return CGSize.init(width: x, height: y)
    }

    public static let bottom = CGPoint(x: 0.5, y: 1)
    public static let top = CGPoint(x: 0.5, y: 1)
    public static let center = CGPoint(x: 0.5, y: 0.5)
}

public extension CGContext {
    private func draw(_ primitive: Primitive, in frame: CGRect) {
        switch primitive {
        case .rectangle:
            fill(frame)
        case .ellipse:
            fillEllipse(in: frame)
        case .text(let text):
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString.init(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        }
    }

    public func draw(_ diagram: Diagram, in bounds: CGRect) {
        let center = CGPoint.init(x: 0.5, y: 0.5)
        switch diagram {
        case let .primitive(size, primitive):
            let bounds = size.fit(into: bounds, alignment: center)
            draw(primitive, in: bounds)
        case .align(let alignment, let diagram):
            let bounds = diagram.size.fit(into: bounds, alignment: alignment)
            draw(diagram, in: bounds)
        case let .beside(left, right):
            let (lBounds, rBounds) = bounds.spit(ratio: left.size.width / diagram.size.width, edge: .minXEdge)
            draw(left, in: lBounds)
            draw(right, in: rBounds)
        case let .below(up, down):
            let (uBounds, dBounds) = bounds.spit(ratio: up.size.height/diagram.size.height , edge: .maxYEdge)
            draw(up, in: uBounds)
            draw(down, in: dBounds)
        case let .attributed(.fillColor(color), diagram):
            saveGState()
            color.set()
            draw(diagram, in: bounds)
            restoreGState()
        }

    }
}

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .maxXEdge || self == .minXEdge
    }
}

extension CGRect {
    func spit(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return devided(atDistance: length * ratio, from: edge)
    }

    func devided(atDistance distance: CGFloat, from: CGRectEdge) -> (CGRect, CGRect) {
        if from.isHorizontal {
            let left = CGRect.init(origin: origin, size: .init(width: distance, height: height))
            let right = CGRect.init(origin: origin.applying(.init(translationX: distance, y: 0)), size: .init(width: width - distance, height: height))
            return (left, right)
        } else {
            let up = CGRect.init(origin: origin, size: .init(width: width, height: distance))
            let down = CGRect.init(origin: origin.applying(.init(translationX: 0, y: distance)), size: .init(width: width, height: height - distance))
            return (up, down)
        }
    }
}
