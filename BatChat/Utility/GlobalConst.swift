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
let lineSize: CGFloat = 0.5
let navHeight: CGFloat = 64
let tabbarHeight: CGFloat = 49
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
