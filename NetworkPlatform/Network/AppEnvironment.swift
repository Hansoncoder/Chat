//
//  AppEnvironment.swift
//  SoMi
//
//  Created by liuchendi on 2019/9/26.
//  Copyright © 2019 liuchendi. All rights reserved.
//

import Foundation

fileprivate let kAppEnv = "kAppEnv"
public enum AppEnvironmentType: Int {
    case develop = 1 // 开发环境
    case release = 2 // appStore 发布环境
    case internalRelease = 3 // 内部发布, 企业包
}

struct AppEnvironment {
    // kAppEnv 没存储表示线上环境
    private static var env: AppEnvironmentType = {
        let value = UserDefaults.standard.integer(forKey: kAppEnv)
        let env = AppEnvironmentType(rawValue: value)
        #if DEBUG
            return env ?? .develop
        #else
            return env ?? .release
        #endif
    }()

    struct URL {
        // 测试服
        static let devEnv = "http://121.4.209.154"
        static let liveTest = "http://kanqiutong.smty8.com"
        static let SJEnv = "http://172.16.10.53:8088"
        
        // 生产环境--发布
        static let releaseEnv = "https://api.kanqiutong.com"
        static let releaseH5 = "https://m.kanqiutong.com"

        static var base: String {
            switch env {
            case .release:
                return releaseEnv
            default:
                return devEnv
            }
        }

        static var Live: String {
            switch env {
            case .release:
                return releaseEnv
            default:
                return liveTest
            }
        }
    }

    public static func change(env: AppEnvironmentType) {
        self.env = env
        UserDefaults.standard.setValue(env.rawValue, forKey: kAppEnv)
        UserDefaults.standard.synchronize()
    }
}

