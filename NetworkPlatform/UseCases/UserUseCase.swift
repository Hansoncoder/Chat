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

}
