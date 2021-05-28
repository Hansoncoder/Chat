//
//  UserUseCase.swift
//  NetworkPlatform
//
//  Created by Hanson on 2020/1/19.
//  Copyright © 2020 Hanson. All rights reserved.
//

import Foundation
import Domain
import RxSwift

let networkProvider = NetworkProvider()
final class UserUseCase: Domain.UserUseCase {
    
    private let network = networkProvider.makeUsersNetwork()

    func login(userName: String, passwd: String) -> Observable<User> {
        return self.network.login(userName, passwd)
    }
    
    func sendCode(phoneNumber: String) -> Observable<Bool> {
        self.network.sendCode(phoneNumber: phoneNumber)
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
