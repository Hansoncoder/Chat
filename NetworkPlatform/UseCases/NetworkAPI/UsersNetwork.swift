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
//    private var network:  Network<User>

    init(baseApi: String) {
        self.servers = baseApi
//        self.network = Network<User>(baseApi)
    }
    
}
