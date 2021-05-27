//
//  GlobalConst.swift
//  Hanson
//
//  Created by Hanson on 9/3/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit

/***** View ******/
let viewBgColor = UIColor.white
let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height
let mainScale: CGFloat = (1.0/UIScreen.main.scale)

let statusBarHeight: CGFloat = UIDevice.is.iPhoneX ? 44 : 20
let bottomSafeAreaHeight: CGFloat = UIDevice.is.iPhoneX ? 34 : 0
let navHeight: CGFloat = 44
let navBottom: CGFloat = statusBarHeight + navHeight
let tabbarHeight: CGFloat = bottomSafeAreaHeight + 49
let APPWINDOW = UIApplication.shared.keyWindow ?? UIWindow()

/****** color ******/
public func navBgColor(_ alpah: CGFloat) -> UIColor {
    return .themeBack
}

// MARK: - keyWindow
var keyWindow: UIWindow {
    keywindows()
}

fileprivate func keywindows() -> UIWindow {
    var keyWindow: UIWindow? = nil
    if #available(iOS 13.0, *) {
        keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    } else {
        // Fallback on earlier versions
        keyWindow = UIApplication.shared.keyWindow
    }
    assert(keyWindow != nil)
    return keyWindow ?? UIWindow()
}
