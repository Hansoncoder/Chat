//
//  BCSessionViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/26.
//

import UIKit
import NetworkPlatform

final class BCSessionViewModel: ViewModelType {
    fileprivate lazy var disposeBag = DisposeBag()
    private var useCase: UserUseCase = netwokData.makeUserUseCase()
    
}


extension BCSessionViewModel {
    public enum JumpType {
        case tabbar // 登陆跳转主页
        case chooseSex  // 选着性别
    }
    
    struct Input {
        let sendMessage: Driver<MessageModelProtocol>
        let jump: Driver<JumpType>
    }
    
    struct Output {
        var messageList: Observable<MessageModelProtocol>
        let error: ErrorTracker
    }
    
    func transform(input: BCSessionViewModel.Input) -> BCSessionViewModel.Output {
        let messageList =  Observable<MessageModelProtocol>.empty()
        let errorTracker = ErrorTracker()
        let countdown = BehaviorRelay<Bool>(value: false)
        
        
        return Output(messageList: messageList,
                      error: errorTracker)
    }
}
