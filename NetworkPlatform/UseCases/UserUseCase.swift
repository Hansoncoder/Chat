//
//  UserUseCase.swift
//  NetworkPlatform
//
//  Created by Hanson on 2020/1/19.
//  Copyright © 2020 Hanson. All rights reserved.
//

import Domain
import Foundation
import RxSwift

final class UserUseCase: Domain.UserUseCase {
    func login(userName: String, passwd: String) -> Observable<User> {
        let network = networkProvider.makeNetwork(User.self)
        let parameters = ["phone": userName, "randomCode": passwd]
        let path = URI.User.regist.value()
        return network.requestModel(path, method: .post, parameters: parameters)
    }

    func sendCode(phoneNumber: String) -> Observable<Bool> {
        let network = networkProvider.makeNetwork(String.self)
        let parameters = ["phone": phoneNumber, "id": phoneNumber]
        let path = URI.Account.sendCode.value(parameters)
        return network.requestModel(path, method: .post, parameters: parameters).flatMapLatest { _ in
            Observable.create { observer -> Disposable in
                observer.on(.next(true))
                observer.on(.completed)
                return Disposables.create()
            }
        }
    }

    func list() -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            let json = ["userName": "sd001", "phone": "123456"]
            if let user = User.decodeJSON(from: json) {
                observer.on(.next([user,user]))
            }
            return Disposables.create()
        }
    }
}
