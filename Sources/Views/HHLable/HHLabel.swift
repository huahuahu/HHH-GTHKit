//
//  HHLabel.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/5.
//

import UIKit

/// 可以指定文字位置的label
public class HHLabel: UILabel {

    /// 文字在垂直方向的对齐方式
    public var verticalAliment: VertialAlignment = .middle

    /// 文字在水平方向的对齐方式
    public var horizontalAliment: HorizontalAlignment = .middle

    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//        self.alignmentRectInsets
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch verticalAliment {
        case .top: rect.origin.y = self.bounds.origin.y
        case .middle: rect.origin.y = self.bounds.midY - rect.height / 2
        case .bottom: rect.origin.y = self.bounds.maxY - rect.height
        }

        switch horizontalAliment {
        case .left: rect.origin.x = self.bounds.origin.x
        case .middle: rect.origin.x = self.bounds.midX - rect.width / 2
        case .right: rect.origin.x = self.bounds.maxX - rect.width
        }
        return rect
    }
    
    public override func drawText(in rect: CGRect) {
        let realRect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: realRect)
    }

}

public extension HHLabel {


    /// 垂直方向的对齐方式
    ///
    /// - top: 顶部对齐
    /// - middle: 居中
    /// - bottom: 底部对齐
    enum VertialAlignment: CaseIterable {
        case top
        case middle
        case bottom
    }


    /// 水平方向的对齐方式
    ///
    /// - left: 左对齐
    /// - middle: 水平居中
    /// - right: 右对齐
    enum HorizontalAlignment: CaseIterable {
        case left
        case middle
        case right
    }
}
