//
//  ContactNavigator.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

protocol ContactNavigator: BCNavigator {
    
}

class DefaultContactNavigator: ContactNavigator {
    var navigator: NavigationController
    var services: UseCaseProvider = netwokData
    required init(navigator: NavigationController) {
        self.navigator = navigator
    }
    
    
    func showDefault() {
        let vc = ContactListViewController()
        navigator.pushViewController(vc, animated: true)
    }
    
}
