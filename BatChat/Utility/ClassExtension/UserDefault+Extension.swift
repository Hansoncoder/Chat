
//
//  UserDefaultExtension.swift
//  YiBiFen
//
//  Created by Hanson on 16/9/2.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import Foundation

let firstLaunch = "firstLaunch"

extension UserDefaults {
    class func bool(forKey key: String) -> Bool {
        return standard.bool(forKey: key)
    }

    class func setValue(_ value: Any?, forKey key: String, synchronize: Bool) {
        standard.setValue(value, forKey: key)
        if synchronize { standard.synchronize() }
    }
}
