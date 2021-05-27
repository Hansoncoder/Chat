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

// AMRK: - 设置四个大小不同的圆角
/// 圆角半径大小
public struct CornerRadii {
    var topLeft: CGFloat = 0  /// 左上
    var topRight: CGFloat = 0 /// 右上
    var bottomLeft: CGFloat = 0 /// 左下
    var bottomRight: CGFloat = 0 /// 右下
    public static var zero: CornerRadii {
        CornerRadii()
    }

    public  init(radius: CGFloat = 0, corner: UIRectCorner = .allCorners) {
        if corner == .allCorners {
            topLeft = radius
            topRight = radius
            bottomLeft = radius
            bottomRight = radius
            return
        }
        
        let mask = 0b0001 //四位二进制
        topLeft = CGFloat((Int(corner.rawValue) & mask)) * radius
        topRight = CGFloat((Int(corner.rawValue >> 1) & mask)) * radius
        bottomLeft = CGFloat((Int(corner.rawValue >> 2) & mask)) * radius
        bottomRight = CGFloat((Int(corner.rawValue >> 3) & mask)) * radius
    }

    public  init(topLeft: CGFloat = 0,
                 topRight: CGFloat = 0,
                 bottomLeft: CGFloat = 0,
                 bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
}

extension UIView {
    
    private struct AssociatedKeys {
        static var radii = "CornerRadii"
    }
    
    
    /// 非动态调整大小请使用cornerRadii(_:)
    internal var radii: CornerRadii? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.radii) as? CornerRadii
        }
        set (radii) {
            UIView.awake()
            objc_setAssociatedObject(self, &AssociatedKeys.radii, radii, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 设置四个不同的圆角
    /// - Parameters:
    ///   - radii: 圆角半径参数
    ///   - isOptimize: 是否动态调整View的大小（默认不调整大小，优化性能）
    public func cornerRadii(_ radii: CornerRadii, isOptimize: Bool = true) {
        /// 没有指定区域，并且设定了动态调整
        if !isOptimize {
            self.radii = radii
        }
        
        addMask(rect: bounds, cornerRadii: radii)
    }
    
    /// 添加遮罩
    /// - Parameters:
    ///   - bounds: 遮罩区域
    ///   - cornerRadii: 圆角半径
    public func addMask(rect: CGRect, path: CGPath? = nil, cornerRadii: CornerRadii = .zero) {
        
        var maskPath: CGPath!
        if path != nil {
            maskPath = path
        } else {
            maskPath = createPathWithRoundedRect(rect: rect, cornerRadii:cornerRadii)
        }
        
        let shapLayer = CAShapeLayer()
        shapLayer.frame = bounds
        shapLayer.path = maskPath
        self.layer.mask = shapLayer
    }

    /// 切圆角函数绘制线条
    func createPathWithRoundedRect(rect: CGRect, cornerRadii: CornerRadii) -> CGPath {
        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY
        
        //获取四个圆心
        let topLeftCenterX = minX +  cornerRadii.topLeft
        let topLeftCenterY = minY + cornerRadii.topLeft
         
        let topRightCenterX = maxX - cornerRadii.topRight
        let topRightCenterY = minY + cornerRadii.topRight
        
        let bottomLeftCenterX = minX +  cornerRadii.bottomLeft
        let bottomLeftCenterY = maxY - cornerRadii.bottomLeft
         
        let bottomRightCenterX = maxX -  cornerRadii.bottomRight
        let bottomRightCenterY = maxY - cornerRadii.bottomRight
        
        //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
        let path :CGMutablePath = CGMutablePath();
         //顶 左
        path.addArc(
            center: CGPoint(x: topLeftCenterX, y: topLeftCenterY),
            radius: cornerRadii.topLeft,
            startAngle: CGFloat.pi,
            endAngle: CGFloat.pi * 3 / 2,
            clockwise: false
        )
        //顶 右
        path.addArc(
            center: CGPoint(x: topRightCenterX, y: topRightCenterY),
            radius: cornerRadii.topRight,
            startAngle: CGFloat.pi * 3 / 2,
            endAngle: 0, clockwise: false
        )
        //底 右
        path.addArc(
            center: CGPoint(x: bottomRightCenterX, y: bottomRightCenterY),
            radius: cornerRadii.bottomRight,
            startAngle: 0,
            endAngle: CGFloat.pi / 2,
            clockwise: false
        )
        //底 左
        path.addArc(
            center: CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY),
            radius: cornerRadii.bottomLeft, startAngle: CGFloat.pi / 2,
            endAngle: CGFloat.pi,
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }

}

// MARK: 执行方法交换
// 请在 didFinishLaunchingWithOptions 调用 UIApplication.runOnce
extension UIView : SwizzlingProtocol {

    static func awake() {
        DispatchQueue.once {
            let originalSelector = #selector(layoutSubviews)
            let swizzledSelector = #selector(swizzled_layoutSubviews)

            UIView.swizzlingForClass(
                UIView.self,
                originalSelector: originalSelector,
                swizzledSelector: swizzledSelector
            )
        }
    }

    /// 交换后的layoutSubviews
    @objc dynamic func swizzled_layoutSubviews() {
        self.swizzled_layoutSubviews()
        /// 解决阴影产生的离屏渲染(有动态调整高度时候，不生效的打开)
        if layer.shadowRadius > 0 {
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        }
        
        guard let radii = self.radii else {
            return
        }
        
        self.addMask(rect: bounds, cornerRadii: radii)
    }
}

// MARK: - Animation
extension UIView {
    static func updateRemoveAnimation(_ update:() -> Void) {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        update()
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
}
