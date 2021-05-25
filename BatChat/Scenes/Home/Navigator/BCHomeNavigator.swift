//
//  HomeNavigator.swift
//  BatChat
//
//  Created by Hanson on 2021/2/3.
//

import UIKit
protocol BCHomeNavigator {
}

class BCDefaultHomeNavigator: BCHomeNavigator, BCNavigator {

    var navigator: NavigationController
    var services: UseCaseProvider = netwokData

    required init(navigator: NavigationController) {
        self.navigator = navigator
    }
    
    func showDefault() {
        let vc = BCSessionViewController()
//        vc.view.backgroundColor = .red
//        vc.viewModel = BCHomeViewModel(navigator: navigator)
        navigator.pushViewController(vc, animated: true)
    }
}
