//
//  NetworkProvider.swift
//  CleanArchitectureRxSwift
//
//  Created by Andrey Yastrebov on 16.03.17.
//  Copyright © 2017 sergdort. All rights reserved.
//

import Domain

final class NetworkProvider {
    /// APP服务环境
    private let domain: String = AppEnvironment.URL.base

    /// 获取用户信息的网络
    public func makeUsersNetwork() -> UsersNetwork {
        return UsersNetwork(baseApi: domain)
    }
}
