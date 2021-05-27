//
//  AdaptViewUntil.swift
//  kanqiusports
//
//  Created by Apple on 2019/12/17.
//  Copyright © 2019 kanqiusports. All rights reserved.
//

import UIKit

func AdaptW(_ viewWidth: CGFloat) -> CGFloat {
    return floor(AdaptViewUntil.sharedInstance.getAdaptWidth(viewWidth: viewWidth))
}

class AdaptViewUntil: NSObject {
    
    let kRefereWidth: CGFloat = 375.0
    
    var _sizeRate:CGFloat
    
    static let sharedInstance = AdaptViewUntil()
    override init() {
        
        _sizeRate = UIScreen.main.bounds.size.width / kRefereWidth;
    }
    
    func getAdaptWidth(viewWidth: CGFloat) -> CGFloat {
        return viewWidth * _sizeRate
    }

}
