//
// Created by DengXiaoBai on 2019-07-22.
// Copyright (c) 2019 mrball. All rights reserved.
//

import UIKit

// MARK: - Factory

extension UIView {
    // line分割线
    public func lineView(_ color: UIColor = .lineColor) -> UIView {
        UIView.lineView(color)
    }

    // MARK: UIView

    public class func lineView(_ backgroundColor: UIColor = .lineColor) -> UIView {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        return view
    }

    // MARK: UITextView

    class func createTextView(textColor: UIColor,
                              backgroundColor: UIColor,
                              font: UIFont,
                              text: String = "",
                              delegate: UITextViewDelegate?) -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.font = font
        textView.text = text
        textView.delegate = delegate

        textView.returnKeyType = .default
        textView.keyboardType = .default
        textView.isScrollEnabled = true
        textView.autoresizingMask = .flexibleHeight
        return textView
    }

    // MARK: UITextField

    class func createTextField(borderStyle: UITextField.BorderStyle = .none,
                               placeholder: String = "",
                               font: UIFont,
                               textAlignment: NSTextAlignment = .left,
                               isSecureTextEntry: Bool = false,
                               delegate: UITextFieldDelegate?) -> UITextField {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = borderStyle
        textField.placeholder = placeholder
        textField.font = font
        textField.textAlignment = textAlignment
        textField.isSecureTextEntry = isSecureTextEntry
        textField.delegate = delegate
        return textField
    }

    // MARK: UIImageView

    class func createImageView() -> UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    class func createImageView(image: UIImage?) -> UIImageView {
        let imageView: UIImageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    class func creatSeparator(_ color: UIColor = UIColor.RGB(239, 239, 244),
                              width: CGFloat = screenW,
                              height: CGFloat = mainScale) -> UIView {
        let v = UIView()
        v.backgroundColor = color

        v.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return v
    }

    // MARK: UITableView

    class func createTableView(delegate: UITableViewDelegate?, dataSource: UITableViewDataSource?, style: UITableView.Style = .plain) -> UITableView {
        let tableView: UITableView = UITableView(frame: .zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets.zero
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        /// 防止iOS11自动启用Self-Sizing
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        /// 防止iOS11自动调整contentInset
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }

    // MARK: - UILabel

    class func createLabel(text: String, textAlignment: NSTextAlignment = .left, font: UIFont, textColor: UIColor = UIColor.black) -> UILabel {
        let label: UILabel = UILabel()
        label.text = text
        label.textAlignment = textAlignment
        label.font = font
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // MARK: - UIVisualEffectView

    class func createBlurView(style: UIBlurEffect.Style) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }

    // MARK: - UIScrollView

    class func createScrollView(delegate: UIScrollViewDelegate?) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = delegate
        scrollView.backgroundColor = UIColor.clear
        /// 防止iOS11自动调整contentInset
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }
}

// MARK: add corners specified corner

extension UIView {
    // 背景渐变色
    @discardableResult
    func gradientLayer(left leftColor: UIColor, right rightColor: UIColor, leftToRight: Bool = false) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.frame = bounds
        if leftToRight {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }

    class func buildGradientLayer(topColor: UIColor = UIColor.RGBA(0, 0, 0, 0), bottomColor: UIColor = UIColor.RGBA(0, 0, 0, 0.4), leftToRight: Bool = false, frame: CGRect = .zero) -> CAGradientLayer {
        let gradientColors = [topColor.cgColor, bottomColor.cgColor]
        // 创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        if leftToRight {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = frame

        return gradientLayer
    }
}

// MARK: reuse id

extension UIView {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }

    class var reuseId: String {
        return String(format: "%@_identifier", nameOfClass)
    }
}

extension UIView {
    var inScreen: Bool {
        guard self.superview != nil, self.window != nil else {
            return false
        }
        let rect = convert(frame, from: nil)
        guard !rect.isEmpty, !rect.isNull, rect != .zero else {
            return false
        }
        
        let interRect = rect.intersection(UIScreen.main.bounds)
        guard !interRect.isEmpty, !interRect.isNull else {
            return false
        }
        return true
    }
}

// MARK: - 阴影

extension UIView {
    func addLightShadow() {
        addShadow(offSet: CGSize(width: 0, height: -3), opacity: 0.04)
    }

    func addShadow(offSet: CGSize = CGSize(width: 0, height: -3),
                   radius: CGFloat = 3,
                   opacity: Float = 0.8,
                   color: UIColor = .shadowColor) {
        clipsToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

    func addCellShadow(offSet: CGSize = CGSize(width: 0, height: 5),
                       opacity: Float = 1, shadowRadius: CGFloat = 6) {
        layer.shadowColor = UIColor(red: 0.53, green: 0.53, blue: 0.56, alpha: 0.1).cgColor

        layer.shadowOffset = offSet
        layer.shadowOpacity = opacity
        layer.shadowRadius = shadowRadius
        clipsToBounds = false
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

    func addCellShadow1() {
        addShadow(offSet: CGSize(width: 0, height: 2), radius: 5, opacity: 1)
    }

    func removeCornerAndShadow() {
        layer.cornerRadius = 0
        radii = nil
        layer.shadowRadius = 0
        layer.shadowPath = nil
        layer.shadowOffset = .zero
        layer.shadowColor = nil
    }
}

extension UIView {
    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
