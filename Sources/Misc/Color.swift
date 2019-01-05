//
//  Color.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/5.
//

import Foundation

public extension UIColor {
    var rgbString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        red = red * 255
        green = green * 255
        blue = blue * 255
        alpha = alpha * 255
        return String.init(format: "#%02x%02x%02x%02x", Int(alpha), Int(red), Int(green), Int(blue))
    }

}
