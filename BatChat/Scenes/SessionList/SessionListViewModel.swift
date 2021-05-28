//
//  SessionListViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

final class SessionListViewModel: ViewModelType {
    lazy var disposeBag = DisposeBag()
    struct Input {
        let toSession: Driver<Void>
    }
    
    struct Output {
    }
    
    private let navigator: SessionListNavigator
    init(navigator: SessionListNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: SessionListViewModel.Input) -> SessionListViewModel.Output {
        input.toSession.do { _ in
            self.navigator.toSession()
        }
        .drive()
        .disposed(by: disposeBag)
        

        return SessionListViewModel.Output()
    }
}
