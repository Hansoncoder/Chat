//
//  SessionListNavigator.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

protocol SessionListNavigator: BCNavigator {
    func toSession()
}

class DefaultSessionNavigator: SessionListNavigator {
    var navigator: NavigationController
    var services: UseCaseProvider = netwokData
    required init(navigator: NavigationController) {
        self.navigator = navigator
    }
    
    
    func showDefault() {
        let vc = SessionListViewController()
        navigator.pushViewController(vc, animated: true)
    }
    
    func toSession() {
        let vc = BCSessionViewController()
        navigator.pushViewController(vc, animated: true)
    }
}
