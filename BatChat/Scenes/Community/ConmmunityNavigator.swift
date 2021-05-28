//
//  ConmmunityNavigator.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

protocol ConmmunityNavigator: BCNavigator {
    
}

class DefaultConmmunityNavigator: ConmmunityNavigator {
    var navigator: NavigationController
    var services: UseCaseProvider = netwokData
    required init(navigator: NavigationController) {
        self.navigator = navigator
    }
    
    
    func showDefault() {
        let vc = ConmmunityViewController()
        navigator.pushViewController(vc, animated: true)
    }
    
}
