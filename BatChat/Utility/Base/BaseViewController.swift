//
//  ViewController.swift
//  forum
//
//  Created by Hanson on 2/1/2020.
//  Copyright © 2020 Hanson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Domain

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    // MARK: - 导航
    var leftItem: CustomItem?
    var rightItem: CustomItem?
    /// 是否允许返回收拾
    var navCanBack: Bool = true {
        didSet {
            let nav = navigationController as? NavigationController
            nav?.canBack = navCanBack
        }
    }
    
    // MARK: - system
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
    }
}

extension BaseViewController {
    
    func setupNavColor(_ color: UIColor = .themeBack) {
        if let nav = navigationController as? NavigationController {
            nav.backgroud(color: color)
        }
    }
    
    func showLeftBar(_ imageName: String?, frame: CGRect = .zero) {
        if leftItem != nil {
            return
        }
        leftItem = CustomItem(imageName)
        navigationItem.leftBarButtonItem = leftItem
        
    }
    
    func showRightBar(_ imageName: String, frame: CGRect = .zero) {
        if rightItem != nil {
            return
        }
        
        rightItem = CustomItem(imageName)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func setupHiddentNav(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navCanBack = false
    }
    
    func setupShowNav(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
}

