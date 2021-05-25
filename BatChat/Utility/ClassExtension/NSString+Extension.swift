//
//  NSString+Extension.swift
//  kanqiusports
//
//  Created by Hanson on 2020/3/2.
//  Copyright © 2020 kanqiusports. All rights reserved.
//

import UIKit

extension String {
    var url: URL? {
        return URL(string: self)
    }
    
    var urlFromFile: URL? {
        return URL(fileURLWithPath: self)
    }
    
    @discardableResult
    public func update(color: UIColor, content: String) -> NSMutableAttributedString {
        let attText = NSMutableAttributedString(string: self)
        return attText.update(color: color, text: content)
    }
    
    func decodeForHTML(with font: UIFont? = nil, color: UIColor? = nil) -> NSAttributedString? {
        do {
            var attributes = ""
            if let font = font {
                attributes = "font-family: \(font.fontName); font-size: \(font.pointSize);"
            }
            
            if let colorHex = color?.hexString {
                attributes.append("color: \(colorHex);")
            }
            
            let cssPrefix = "<style>* { \(attributes) }</style>"
            let html = cssPrefix + self
            
            guard let data = html.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
}

extension String {
    
    public func attrText(_ font: UIFont, color: UIColor) -> NSMutableAttributedString {
        let attrText = NSMutableAttributedString(string: self)
        attrText.addAttributes([
            .foregroundColor : color,
            .font : font
        ], range: allRange())
        return attrText
    }
}

extension NSMutableAttributedString {
    public func lineSpacing(_ lineSpacing: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.lineBreakMode = .byTruncatingTail
        addAttributes([NSAttributedString.Key.paragraphStyle : style], range: string.allRange())
    }
    
    public func updateColor(_ color: UIColor, font: UIFont? = nil, text: String) {
        update(color: color, text: text)
    }
    
    @discardableResult
    public func update(color: UIColor? = nil, font: UIFont? = nil, text: String) -> NSMutableAttributedString {
        let ranges = string.nsRanges(of: text)
        ranges.forEach {
            if let color = color {
                addAttributes([.foregroundColor: color], range: $0)
            }
            if let font = font {
                addAttributes([.font: font], range:  $0)
            }
        }
        return self
    }

    @discardableResult
    public func update(color: UIColor? = nil, font: UIFont? = nil, firstText: String) -> NSMutableAttributedString {
        let range = (string as NSString).range(of: firstText)
        if let color = color {
            addAttributes([.foregroundColor: color], range: range)
        }
        if let font = font {
            addAttributes([.font: font], range: range)
        }
        return self
    }

    @discardableResult
    public func update(color: UIColor? = nil, font: UIFont? = nil, lastText: String) -> NSMutableAttributedString {
        guard let range = string.nsRanges(of: lastText).last else {
            return self
        }
        if let color = color {
            addAttributes([.foregroundColor: color], range: range)
        }
        if let font = font {
            addAttributes([.font: font], range: range)
        }
        return self
    }
}

extension String {
    
    func hidePhoneNumber() -> String {
        if self.count < 5 {
            var str = ""
            for _ in 0 ..< self.count {
                str += "*"
            }
            return str
        } else {
            //替换一段内容，两个参数：替换的范围和用来替换的内容
            let start = self.index(self.startIndex, offsetBy: (self.count - 5) / 2)
            let end = self.index(self.startIndex, offsetBy: (self.count - 5) / 2 + 4)
            let range = Range(uncheckedBounds: (lower: start, upper: end))
            return self.replacingCharacters(in: range, with: "****")
        }
    }
    
    func hideEmail() -> String {
        var mail = self
        let arraySubstrings: [Substring] = mail.split(separator: "@")
        let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" } // i将Substring转为string
        var str = ""
        if arrayStrings[0].count < 3 {
            for _ in 0 ..< arrayStrings[0].count {
                str += "*"
            }
            return str + arrayStrings[1]
        } else {
        for _ in 0 ..< arrayStrings[0].count - 2 {
            str += "*"
        }
            let start = mail.index(mail.startIndex, offsetBy: 1)
            let end = mail.index(mail.startIndex, offsetBy: arrayStrings[0].count - 2)
            let range = Range(uncheckedBounds: (lower: start, upper: end))
            mail.replaceSubrange(range, with: str)
            return mail
        }
        
    }
}

extension String {
    public func removeFirstName()-> String {
        let list = self.split(separator: "·")
        return String(list.last ?? "")
    }
}


extension String {
    public func add(_ string: String) -> String {
        return self + string
    }
    
    public func pre(_ string: String) -> String {
        return string + self
    }
}

extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return boundingBox.height
    }

    func width(height:CGFloat, font:UIFont) -> CGFloat {
        let Rect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: Rect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return boundingBox.width
    }

}

// MARK: - range
extension String {

    var attributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    var mutableAttributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    var nsString: NSString {
        return self as NSString
    }
    
    
    func allRange() -> NSRange{
        return NSMakeRange(0, self.count)
    }

    public func nsRanges(of string: String) -> [NSRange] {
        return ranges(of: string).map {
            (range) -> NSRange in
            self.nsRange(from: range)
        }
    }


    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = range(of: self) else {
            return rangeArray
        }
        searchedRange = sr

        var resultRange = range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }

    func toNSRange(fromRange range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }


    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }

}

// MARK: 数字转中文 102--> 一百零二
extension Int {
    var cn: String {
        get {
            if self == 0 {
                return "零"
            }
            let zhNumbers = [
                "零", "一", "二", "三", "四",
                "五", "六", "七", "八", "九"
            ]
            let units = [
                "", "十", "百", "千", "万",
                "十", "百", "千", "亿",
                "十","百","千"
            ]
            
            var cn = ""
            var currentNum = 0
            var beforeNum = 0
            let intLength = Int(floor(log10(Double(self))))
            for index in 0...intLength {
                currentNum = self/Int(pow(10.0,Double(index)))%10
                if index == 0{
                    if currentNum != 0 {
                        cn = zhNumbers[currentNum]
                        continue
                    }
                } else {
                    beforeNum = self/Int(pow(10.0,Double(index-1)))%10
                }
                if [1,2,3,5,6,7,9,10,11].contains(index) {
                    if currentNum == 1 && [1,5,9].contains(index) && index == intLength { // 处理一开头的含十单位
                        cn = units[index] + cn
                    } else if currentNum != 0 {
                        cn = zhNumbers[currentNum] + units[index] + cn
                    } else if beforeNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                    continue
                }
                if [4,8,12].contains(index) {
                    cn = units[index] + cn
                    if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                }
            }
            return cn
        }
    }
}

//MARK: - 精度丢失修复

// 数据工具
extension Double {
    public var string: String {
        let string = NSString(format: "%lf", self) as String
        return NSDecimalNumber(string: string).stringValue
    }
}

extension Float {
    public var string: String {
        return NSNumber(value: self).stringValue
    }
}


extension UIImageView {
    public func setGifImage(_ name: String) {
        var realName = name + "@2x"
        if !UIDevice.is.iPhone5 ||
            !UIDevice.is.iPhone6 {
            realName = name + "@3x"
        }
        guard let path = Bundle.main.path(
            forResource: realName,
            ofType: "gif") else {
            return
        }

        let provider = LocalFileImageDataProvider(
            fileURL: URL(fileURLWithPath: path)
        )

        kf.setImage(
            with: provider,
            options: [.scaleFactor(UIScreen.main.scale)]
        )
    }
}


extension String {
    
// MARK: - 传入高度，返回文字宽度
    func textSize(with font: UIFont, maxHeight: CGFloat) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        // swift NSParagraphStyleAttributeName 变成了
        var attrs = [NSAttributedString.Key : Any]()
        attrs[NSAttributedString.Key.font] = font
        attrs[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        let maxSize = CGSize.init(width: CGFloat(MAXFLOAT), height: maxHeight)
        
        self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
// MARK: - 传入宽度，返回文字高度
    func textSize(with font: UIFont, maxWidth: CGFloat) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        var attrs = [NSAttributedString.Key: Any]()
        attrs[NSAttributedString.Key.font] = font
        attrs[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        let maxSize = CGSize.init(width: maxWidth, height: CGFloat(MAXFLOAT))
        
//        let aa = 1 | 2
//        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        // 用swift 怎么写???
//        let option = NSStringDrawingOptions.usesLineFragmentOrigin | NSStringDrawingOptions.usesFontLeading
        
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
    func attributedString(_ contentString: String, changeStr: String) -> NSAttributedString {
        
        let rangeStr = changeStr
        let attriString = NSMutableAttributedString(string: contentString)
        
        //1.先把String转换成 NSStiring
        let nsString = NSString(string: attriString.string)

        //2.NSString中的range方法获取到的是NSRange类型
        let nsRange = nsString.range(of: rangeStr)
        
        attriString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hexString: "#999999")], range: nsRange)
        return attriString.copy() as! NSAttributedString
    }
}

extension NSAttributedString {
    // 传入attributedText宽度，计算attributedText文字的高度
    func sizeWithAttributedText(width: CGFloat) -> CGSize {
            
        let maxSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let options = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)
        
        return boundingRect(with: maxSize, options: options, context: nil).size
    }
}

// MARK: - value 是AnyObject类型是因为有可能所传的值不是String类型，有可能是其他任意的类型。
func DYStringIsEmpty(value: AnyObject?) -> Bool {
    //首先判断是否为nil
    if (nil == value) {
        //对象是nil，直接认为是空串
        return true
    }else{
        //然后是否可以转化为String
        if let myValue  = value as? String{
            //然后对String做判断
            return myValue == "" || myValue == "(null)" || 0 == myValue.count
        }else{
            //字符串都不是，直接认为是空串
            return true
        }
    }
}
