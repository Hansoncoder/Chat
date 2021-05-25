//
//  BundleInfoUtils.swift
//  EvolutionSports
//
//  Created by liuchendi on 2019/5/29.
//  Copyright © 2019 mrball. All rights reserved.
//

import Foundation

let appName = BundleInfo.bundleName
struct BundleInfo {
    static var infoDictionary: Dictionary<String, Any> {
        if let bundle =  Bundle.main.infoDictionary {
            return bundle
        }
        return [:]
    }
    
    static var bundleName: String {
        if let v = infoDictionary["CFBundleName"] as? String {
            return v
        }
        return ""
    }
    
    static var version: String {
        if let v = infoDictionary["CFBundleShortVersionString"] as? String {
            return v
        }
        return ""
    }
    
    static var build: String {
        if let v = infoDictionary["CFBundleVersion"] as? String {
            return v
        }
        return ""
    }
    
    static var bundleId: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
}
