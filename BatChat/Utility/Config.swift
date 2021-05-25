//
//  GlobalConfiguration.swift
//  SoMi
//
//  Created by liuchendi on 2019/9/26.
//  Copyright © 2019 liuchendi. All rights reserved.
//

import Foundation
import KeychainAccess

// 公共的设备、APP配置参数
struct Comment {
    public static let copyright = "XXX 2020"
    public static let email = "hansoncoder@gmail.com"
    
    public static let appId = ""
    public static var deviceToken = ""
    public static var deviceId: String {
        return getNewUDID()
    }
}

/** 存储Keychain的 Service key*/
fileprivate let kServiceID = "com.zuoying.batchat"
/** 存储Keychain的 Group key*/
fileprivate let kAccessGroup = "com.zuoying.batchat"
/** 存储Keychain的 account key*/
fileprivate let kAccount = "batchat"
// 获取设备唯一标识
func getNewUDID() -> String {
    
    let keychain = Keychain(service: kServiceID, accessGroup: kAccessGroup)
    var udid = try? keychain.getString(kAccount)
    
    guard udid != nil else {
        
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        udid = strRef! as String
        
        do {
            try keychain
                .accessibility(.whenUnlocked)
                .set(udid!, key: kAccount)
        } catch let error {
            print("error: \(error)")
        }
        
        return udid!
    }
    return udid!
}
