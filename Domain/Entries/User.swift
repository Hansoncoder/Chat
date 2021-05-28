//
//  User.swift
//  Domain
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

public enum SexType: Int, ECodable {
    case unowned = 0
    case boy = 1
    case girl = 2
}

public struct User: ECodable {

    
    /// 当前登录的用户
    public static var share: User = {
        let user = UserDefaults.value(forKey: "user")
        return user as! User
    }()
//    public let address: Address
    
    public let portrait: String
    public let email: String
    public let name: String
    public let phone: String
    public let token: String
    public let userId: String
    public let userName: String
    public let website: String
    public let sex: SexType
    
    public let hxUsername: String
    public let hxPassword: String
    public let isLogin: String
}
