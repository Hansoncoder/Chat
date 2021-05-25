//
//  UILabel+Extension.swift
//  forum
//
//  Created by Hanson on 2020/12/13.
//  Copyright © 2020 Hanson. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func create(text: String = "", textAlignment: NSTextAlignment = .left, font: UIFont, textColor: UIColor = .blackText)
    -> UILabel {
        let label = UILabel()
        label.setup(font, textColor, textAlignment)
        label.text = text
        return label
    }

    func set(text: String?, align: NSTextAlignment, font: UIFont, color: UIColor) {
        self.text = text
        textAlignment = align
        self.font = font
        textColor = color
    }

    /// UILabel根据文字的需要的高度
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: CGFloat.greatestFiniteMagnitude)
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }

    /// UILabel根据文字实际的行数
    public var lines: Int {
        return Int(requiredHeight / font.lineHeight)
    }
}

extension UILabel {
    public func setup(_ font: UIFont, _ textColor: UIColor, _ textAlignment: NSTextAlignment = .left) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }

    public func setup(from label: UILabel, isAlignment: Bool = true) {
        font = label.font
        textColor = label.textColor
        if isAlignment {
            textAlignment = label.textAlignment
        }
    }
}
