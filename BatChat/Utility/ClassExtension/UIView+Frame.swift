//
//  UIView+Frame.swift
//  YiBiFen
//
//  Created by Hanson on 16/9/2.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import UIKit

extension UIView {

    var left: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }

    var right: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.width
            self.frame = frame
        }
        get {
            return self.left + self.width
        }
    }

    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }

    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }

    var top: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }

    var bottom: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.height
            self.frame = frame
        }
        get {
            return self.top + self.height
        }
    }

    var centerY: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height * 0.5
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height * 0.5
        }
    }

    var centerX: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width * 0.5
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width * 0.5
        }
    }

    var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
}

// MARK: - 圆角
extension UIView {
    
    /// 设置圆角边框
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    func corner(radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        cornerRadius(radius: radius, borderWidth: borderWidth, borderColor: borderColor)
    }

    /// 设置指定角的圆角
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - rectCorner: 指定切圆角的角
    func cornerRadius(radius: CGFloat, rectCorner: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = CACornerMask(rawValue: rectCorner.rawValue)
        if borderWidth > 0 {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor?.cgColor
        }
    }
}
