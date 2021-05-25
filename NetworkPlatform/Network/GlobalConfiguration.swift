//
//  GlobalConfiguration.swift
//  SoMi
//
//  Created by liuchendi on 2019/9/26.
//  Copyright © 2019 liuchendi. All rights reserved.
//

import Foundation

// 公共的设备、APP配置参数
struct Comment {
    public static let copyright = "看球网络科技有限公司 2019"
    public static let email = "kanqiutong@foxmail.com"
    public static let QQ = "269434989"
    public static let tel = "40000-222220"
    
    public static let appId = "1502046543"
    public static var deviceToken = ""
    public static var deviceId: String {
        return "getNewUDID()"
    }
    
    
    /// 接口
    public static let channel = 7 // 渠道ID
    ///平台: 1-PC、2-iOS、3-安卓、4-H5，5-CMS，6-system
    public static let platform = 2 // 平台ID
    public static let language = "zh" // 语言ID
}

class GlobalConfiguration: NSObject {

    /// 共用parameters
    static var commonParameters:[String:Any]{
        return ["platform" : Comment.platform,
                "channelId" : Comment.channel,
                "lang"     : Comment.language,
//                "ver"    : bundleVersion,
//                "pkg"    : BundleInfo.bundleId,
                "os"     : "1",
                "cid"    : Comment.channel]
    }
}
