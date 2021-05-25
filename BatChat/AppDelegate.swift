//
//  AppDelegate.swift
//  BatChat
//
//  Created by Hanson on 2021/2/3.
//

import UIKit
import Domain

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        Application.shared.showTabbar()
        
        
        return true
    }

}

