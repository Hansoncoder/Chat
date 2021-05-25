//
//  URI.swift
//  NetworkPlatform
//
//  Created by Hanson on 2020/11/3.
//  Copyright © 2020 Hanson. All rights reserved.
//

import Foundation

protocol URLAble {
    func value(_: [String: Any]?) -> String
}

enum URI {
    enum Test: String, URLAble {
        case test = "/live/data/schedule/index"

        func value(_ param: [String: Any]? = nil) -> String {
            return rawValue.appendId(param)
        }
    }
    
    enum Account: String, URLAble {
        case sendCode = "/api/sms/sendcode"
        case regist = "/api/login/regist"
        func value(_ param: [String: Any]? = nil) -> String {
            return rawValue.appendId(param)
        }
    }
    
    enum User: String, URLAble {
        case regist = "/api/login/regist"
        func value(_ param: [String: Any]? = nil) -> String {
            return rawValue.appendId(param)
        }
    }
    
}


//MARK: - 处理数据参数
extension String {
    
    /// 拼接参数 XXX/{param["id"]}，
    /// param的 key 包含 "id"， value为Int或String
    public func appendId(_ param: [String: Any]?) -> String {
        guard let param = param else {
           return self
        }
        
        if let id = param["id"] as? Int {
            return self + "/\(id)"
        }
        
        if let id = param["id"] as? String {
            return self + "/\(id)"
        }
        
        #if DEBUG
        print("\(self):参数拼接错误")
        #endif
        
        return self
    }
}
