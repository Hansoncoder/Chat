//
//  Navigator.swift
//  forum
//
//  Created by Hanson on 2020/1/11.
//  Copyright © 2020 Hanson. All rights reserved.
//

import UIKit
import Domain

protocol BCNavigator {
    var navigator: NavigationController { get set }
    var services: UseCaseProvider { get set }
    init(navigator: NavigationController)
    
    func showDefault()
}
