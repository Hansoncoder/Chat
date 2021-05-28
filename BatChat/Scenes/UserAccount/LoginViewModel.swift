//
//  LoginViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

final class LoginViewModel: ViewModelType {
    lazy var disposeBag = DisposeBag()
    private var useCase: UserUseCase = netwokData.makeUserUseCase()
    private let navigator: AccountNavigator
    init(useCase: UserUseCase, navigator: AccountNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
}


extension LoginViewModel {
    public enum JumpType {
        case tabbar // 登陆跳转主页
        case chooseSex  // 选着性别
    }
    
    
    struct Input {
        let userName = BehaviorRelay<String>(value: "")
        let verifyCode = BehaviorRelay<String>(value: "")
        let login: Driver<Void>
        let sendCode: Driver<Void>
        let jump: Driver<JumpType>
    }
    struct Output {
        var countdown: Observable<Bool>
        let fetching: Driver<Bool>
        let error: ErrorTracker
    }
    
    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        let activityIndicator =  BehaviorRelay<Bool>(value: false)
        let errorTracker = ErrorTracker()
        let countdown = BehaviorRelay<Bool>(value: false)
        input.login.flatMapLatest {
            return self.useCase.login(userName: input.userName.value, passwd: input.verifyCode.value)
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
            .asDriverOnErrorJustComplete()
            .asDriver()
        }
        .do(onNext: {
            [weak self] user in
            if user.phone == "15013789132" {
                self?.navigator.goTabbar()
                return
            }
            self?.navigator.goTabbar()
        })
        .drive()
        .disposed(by: disposeBag)
        
        input.sendCode.flatMapLatest {
            self.useCase.sendCode(phoneNumber: input.userName.value)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .asDriver()
        }
        .drive()
        .disposed(by: disposeBag)

        
        return Output(countdown: countdown.asObservable(),
                      fetching: activityIndicator.asDriver(),
                      error: errorTracker)
    }
}
