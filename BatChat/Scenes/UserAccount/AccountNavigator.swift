//
//  AccountNavigator.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

protocol AccountNavigator: BCNavigator {
    /// 跳转主页
    func goTabbar()
}

extension DefaulAccountNavigator {
    func goTabbar() {
        Application.shared.showTabbar()
    }
}


class DefaulAccountNavigator: AccountNavigator {
    var navigator: NavigationController
    var services: UseCaseProvider = netwokData
    required init(navigator: NavigationController) {
        self.navigator = navigator
    }
    
    
    func showDefault() {
        let vc = LoginViewController()
        navigator.pushViewController(vc, animated: true)
    }
    
}
