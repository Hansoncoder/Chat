//
//  UsersNetwork.swift
//  CleanArchitectureRxSwift
//
//  Created by Andrey Yastrebov on 16.03.17.
//  Copyright © 2017 sergdort. All rights reserved.
//

import Domain
import RxSwift
import Hyphenate

public final class UsersNetwork {
    private var servers: String = ""
    private var network:  Network<User>

    init(baseApi: String) {
        self.servers = baseApi
        self.network = Network<User>(baseApi)
    }
    
    /// 注册
    public func signup(_ userName: String,_ passwd: String) -> Observable<User> {
        let parameters = ["phone": userName, "randomCode": passwd]
        let path = URI.User.regist.value()
        return network.requestModel(path, method: .post, parameters: parameters)
    }
    
    public func login(_ userName: String,_ passwd: String) -> Observable<User> {
        /// 后台注册
        return signup(userName, passwd).flatMapLatest({ (user) -> Observable<User> in
            /// 环信登录
            return Observable.create { observer -> Disposable in
                EMClient.shared()?.login(withUsername: user.hxUsername, password: user.hxPassword) {
                    (aUsername, aError) in
                    if let error = aError {
                        let error = DSError(
                            code: Int(error.code.rawValue),
                            message: error.errorDescription
                        )
                        observer.on(.error(error))
                        return
                    }
                    observer.on(.next(user))
                    observer.on(.completed)
                }

                return Disposables.create()
            }
        })
    }
    
    public func sendCode(phoneNumber: String) -> Observable<Bool> {
        let network = Network<String>(servers)
        let parameters = ["phone": phoneNumber, "id":phoneNumber]
        let path = URI.Account.sendCode.value(parameters)
        return network.requestModel(path, method: .post, parameters: parameters).flatMapLatest { _ in
            Observable.create { observer -> Disposable in
                observer.on(.next(true))
                observer.on(.completed)
                return Disposables.create()
            }
        }
    }
}
