//
//  Regular.swift
//  FanMile
//
//  Created by Hanson on 2020/3/31.
//  Copyright © 2020 Hanson. All rights reserved.
//

import Foundation

public enum RegexType: String {
    // 手机号： 1、3～9、9位数字
    case phoneNumber = "^1[3-9]\\d{9}$"
    
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case passWord = "(?!^\\d+$)(?!^[A-Za-z]+$)(?!^[^A-Za-z0-9]+$)(?!^.*[\\u4E00-\\u9FA5].*$)^\\S{6,20}$"
    case nickname = "^[\u{4e00}-\u{9fa5}]{4,8}$"
    // 身份证号
    case idNumber = "(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)"

    
    func predicate() -> NSPredicate {
        return NSPredicate(format: "SELF MATCHES %@", self.rawValue)
    }
}

extension String {

    public func validate(regex: RegexType) -> Bool {
        let phonePredicate = regex.predicate()
        return phonePredicate.evaluate(with: self)
    }
    
    public var isPhoneNumber: Bool {
        return validate(regex: .phoneNumber)
    }
    
    // 身份证号
    public var isIdNumber: Bool {
        return validate(regex: .idNumber)
    }
    
    public var isPassword: Bool {
        if validate(regex: .passWord) { return true }
        return false
    }
    
}
