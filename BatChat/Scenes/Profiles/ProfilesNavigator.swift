//
//  ProfilesNavigator.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

protocol ProfilesNavigator: BCNavigator {
    
}

class DefaultProfilesNavigator: ProfilesNavigator {
    var navigator: NavigationController
    var services: UseCaseProvider = netwokData
    required init(navigator: NavigationController) {
        self.navigator = navigator
    }
    
    
    func showDefault() {
        let vc = ProfilesViewController()
        navigator.pushViewController(vc, animated: true)
    }
    
}
