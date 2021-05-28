//
//  UserUseCase.swift
//  Domain
//
//  Created by Hanson on 2020/1/19.
//  Copyright © 2020 Hanson. All rights reserved.
//
import RxSwift

public protocol UserUseCase {
    func login(userName: String, passwd: String) -> Observable<User>
    func sendCode(phoneNumber: String) -> Observable<Bool>
}
