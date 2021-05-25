//
//  UIDevice+Extension.swift
//  forum
//
//  Created by Hanson on 2020/12/13.
//  Copyright © 2020 Hanson. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    struct `is` {
        static let iPhone5: Bool = UIDevice.iPhone5
        static let iPhone6: Bool = UIDevice.iPhone6
        static let iPhone6Plus: Bool = UIDevice.iPhoneX
        static let iPhoneX: Bool = UIDevice.iPhoneX
        static let iPhoneXSMax: Bool = UIDevice.iPhoneXSMax
        static let iPhoneXR: Bool = UIDevice.iPhoneXR
    }
    
    class var iPhone5: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 1136 { return true}
            return false
        }
        
        return false
    }
    class var iPhone6: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 1334 { return true}
            return false
        }
        
        return false
    }
    class var iPhoneXSMax: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            let h = UIScreen.main.nativeBounds.height
            if h == 2688 { return true }
        }
        return false
    }
    
    class var iPhoneXR: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            let h = UIScreen.main.nativeBounds.height
            if h == 1792 { return true }
        }
        return false
    }
    
    class var iPhoneX: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136: //iPhone 5 or 5S or 5C
                return false
                
            case 1334: // iPhone 6/6S/7/8

                return false
            case 1920, 2208: // iPhone 6+/6S+/7+/8+

                return false
            case 2436, 2532: // iPhone X, XS, 12

                return true
                
            case 2688, 2778: //viPhone XS Max  12Max

                return true
                
            case 1792, 2340: // iPhone XR, 12 Mini

                return true
                
            default: break
                
            }
        }
        return false
    }
    
    class func getNavAndBarHeight() -> CGFloat {
        if `is`.iPhoneX {
            return 84.0
        }
        return 64.0
    }
    class func getBarHeight() -> CGFloat {
        if `is`.iPhoneX {
            return 40.0
        }
        return 20.0
    }
    
    class func getNavHeight() -> CGFloat {
        return 44.0
    }
    
    class func getTabHeight() -> CGFloat
    {
        return 49.0
    }
    
    class func getFullTabHeight() -> CGFloat
    {
        return 49.0+self.getSafeHeight()
    }
    
    class func getSafeHeight() -> CGFloat {
        if `is`.iPhoneX {
            return 34.0
        }
        return 0.0
    }
    
    class func getWithoutNavTabHeight() -> CGFloat {
        return UIScreen.main.bounds.height-UIDevice.getSafeHeight()-UIDevice.getNavAndBarHeight()-UIDevice.getTabHeight()
    }
    
    class var isSimulator: Bool {
        return (TARGET_IPHONE_SIMULATOR == 1)
    }
}

