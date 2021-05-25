//
//  UIImage+Extension.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/16.
//  Copyright © 2018年 Hanson. All rights reserved.
//

import UIKit


enum ImagePosition {
    case center
    case bottomRight
}


extension UIImage {
    
    /// 图片边框保护 拉伸模式
    var resizable: UIImage {
        return stretchableImage(withLeftCapWidth: Int(size.width * 0.5),
                                topCapHeight: Int(size.height * 0.5))
    }
}


public extension UIColor {
    var image: UIImage? {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
           UIGraphicsBeginImageContext(rect.size)
           let context = UIGraphicsGetCurrentContext()
           context?.setFillColor(self.cgColor)
           context?.fill(rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
    }
}


public extension String {

    var image: UIImage? {
        return UIImage(named: self)
    }

    var selectImage: UIImage? {
        return UIImage(named: "icon_\(self)_sel")?
            .withRenderingMode(.alwaysOriginal)
    }

    var normalImage: UIImage? {
        return UIImage(named: "icon_\(self)_nor")?
            .withRenderingMode(.alwaysOriginal)
    }
}
