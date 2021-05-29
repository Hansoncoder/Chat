//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Hanson on 2021/2/3.
//

import Domain
import Foundation

let networkProvider = NetworkProvider()
public final class UseCaseProvider: Domain.UseCaseProvider {
    private let networkProvider: NetworkProvider

    public init() {
        networkProvider = NetworkProvider()
    }

    /// 提供用户信息的 用例
    public func makeUserUseCase() -> Domain.UserUseCase {
        return UserUseCase()
    }

    public func makeSessionUseCase() -> Domain.SessionUseCase {
        return SessionUseCase()
    }
}
