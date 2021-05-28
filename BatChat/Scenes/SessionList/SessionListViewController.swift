//
//  SessionListViewController.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

class SessionListViewController: BaseViewController {

    lazy var viewModel = SessionListViewModel(navigator: DefaultSessionNavigator(navigator: navigationController as! NavigationController))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        bindViewModel()
    }
    
    // MARK: - setupUI
    private func setupNav() {
        navBar.title = "聊天"
        navBar.titleLabel.textColor = .white
        navBar.setRightButton(image: "icon_nav_add_white".image!)
        addNavBackColor(left: "#00B6B3".color, right: "#0FE7C3".color)
        
        
        let showFeat = navBar.rightButton.rx.controlEvent(.touchUpInside)
    }

    // MARK: - bind
    private func bindViewModel() {
        let touchBegin = rx.sentMessage(#selector(UIViewController.touchesBegan(_:with:)))
               .mapToVoid()
               .asDriverOnErrorJustComplete()
        
        let input = SessionListViewModel.Input(toSession: touchBegin)
        let output = viewModel.transform(input: input)
    }
}
