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


class BaseViewController: UIViewController, NavigationProtocol {
    
    lazy var navBar: EFNavigationBar = setupNavBar()
    
    
    let disposeBag = DisposeBag()
    /// 是否允许返回收拾
    var navCanBack: Bool = true {
        didSet {
            let nav = navigationController as? NavigationController
            nav?.canBack = navCanBack
        }
    }
    
    // 隐藏状态栏
    var isStatusBarHidden = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    /// 使用底部阴影
    open var adjustNavBarToFront = false
    open var navBarShowShadow: Bool = false {
        didSet {
            if navBarShowShadow {
                adjustNavBarToFront = true
                navBar.setBottomLineHidden(hidden: true)
                navBar.addCellShadow1()
                return
            }
            
            adjustNavBarToFront = false
            navBar.removeCornerAndShadow()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random
        navBar.title = ""
        if #available(iOS 13.0, *) {
            modalPresentationStyle = .fullScreen
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if adjustNavBarToFront {
            view.bringSubviewToFront(navBar)
        }
    }
}
/// 所有控制器，点击空白收起键盘
extension BaseViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
