//
//  Color+HexColor.swift
//  kanqiusports
//
//  Created by Apple on 2019/12/17.
//  Copyright © 2019 kanqiusports. All rights reserved.
//

import UIKit

public var DebugColor = false

extension UIColor {
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let a = Int(color >> 24) & mask
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        var alpha = CGFloat(a) / 255.0
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0

        if hexString.count < 8 {
            alpha = 1
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // 用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(hex hexText: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hexText & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexText & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexText & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    class func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return RGBA(r, g, b, 1)
    }

    class func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    convenience init?(hexRGBString: String?, alpha: CGFloat = 1.0) {
        guard let intString = hexRGBString?.replacingOccurrences(of: "#", with: "") else { return nil }
        guard let hex = UInt(intString, radix: 16) else {
            return nil
        }
        self.init(hex: hex, alpha: alpha)
    }
    
    class func hexadecimalColor(hexadecimal: String) -> UIColor {
        var cstr = hexadecimal.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if (cstr.length < 6) {
            return UIColor.clear;
        }
        if (cstr.hasPrefix("0X")) {
            cstr = cstr.substring(from: 2) as NSString
        }
        if (cstr.hasPrefix("#")) {
            cstr = cstr.substring(from: 1) as NSString
        }
        if (cstr.length != 6) {
            return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r: UInt32 = 0x0;
        var g: UInt32 = 0x0;
        var b: UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1);
    }

    open class var random:UIColor{
        get{
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

extension String {
    public var color: UIColor {
        return UIColor(hexString: self)
    }
    
    public func color(alpha: CGFloat) -> UIColor {
        return UIColor(hexRGBString: self, alpha: alpha / 100.0) ?? self.color
    }
}


// MARK: - back

extension UIColor {
    open class var themeBack: UIColor {
        return .init(hex: 0xFF7E90)
    }

    open class var backColor: UIColor {
        return .init(hex: 0xF5F5F5)
    }
    
    open class var lineColor: UIColor {
        return .init(hex: 0xD8D8D8)
    }
    
    open class var shadowColor: UIColor {
#if DEBUG
        if DebugColor { return .red }
#endif
        return "#88888F".color(alpha: 8)
    }
}

// MARK: - text

extension UIColor {

    open class var blackText: UIColor {
        return .init(hex: 0x333333)
    }

    open class var darkGrayText: UIColor {
        return .init(hex: 0x666666)
    }
    
    open class var grayText: UIColor {
        return .init(hex: 0x999999)
    }
}
