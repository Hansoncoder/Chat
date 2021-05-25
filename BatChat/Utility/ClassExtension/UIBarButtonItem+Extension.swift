//
//  UIBarButtonItem+Extension.swift
//  forum
//
//  Created by Hanson on 4/1/2020.
//  Copyright © 2020 Hanson. All rights reserved.
//

import RxCocoa
import RxSwift

extension UIBarButtonItem {
    
    typealias customView = () -> Void ///< 定义确认回调
    public convenience init(imageName: String?,
                            selected selectImageName: String? = nil,
                            target: Any? = nil,
                            action: Selector? = nil) {
        if let name = imageName {
            self.init(image: UIImage(named: name), style: .plain, target: nil, action: nil)
            return
        }
        
        self.init(title:" ", style: .plain, target: nil, action: nil)
    }
}
