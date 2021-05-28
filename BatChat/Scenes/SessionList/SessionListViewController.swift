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
        
        let touchBegin = rx.sentMessage(#selector(UIViewController.touchesBegan(_:with:)))
               .mapToVoid()
               .asDriverOnErrorJustComplete()
        
        let input = SessionListViewModel.Input(toSession: touchBegin)
        let output = viewModel.transform(input: input)
    }
    

}
