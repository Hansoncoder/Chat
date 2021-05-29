//
//  InsetLabel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/29.
//

import UIKit

class InsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero
    func setBorder(radius: CGFloat, width: CGFloat) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = textColor.cgColor
    }
    
    /// 扩展一个padding方法
    func padding(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        textInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += textInsets.top + textInsets.bottom
            contentSize.width += textInsets.left + textInsets.right
            return contentSize
        }
    }
}

