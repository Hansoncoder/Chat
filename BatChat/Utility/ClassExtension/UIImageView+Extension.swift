//
//  UIImageView+Extension.swift
//  YiBiFen
//
//  Created by Hanson on 16/10/14.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import UIKit

public extension UIImage {

    // MARK: Image from solid color
    /**
     Creates a new solid color image.
     
     - Parameter color: The color to fill the image with.
     - Parameter size: Image size (defaults: 10x10)
     
     - Returns A new image
     */
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

}
