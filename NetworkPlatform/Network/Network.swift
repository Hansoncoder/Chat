//
//  Network.swift
//  CleanArchitectureRxSwift
//
//  Created by Andrey Yastrebov on 16.03.17.
//  Copyright © 2017 sergdort. All rights reserved.
//

import Alamofire
import Domain
import Foundation
import RxAlamofire
import RxSwift

final class NetworkProvider {
    /// APP服务环境
    private let domain: String = AppEnvironment.URL.base

    public func makeNetwork<M: ECodable>(_ type: M.Type) -> Network<M> {
        return Network<M>(domain)
    }
}

public struct NetworkData<T: Decodable>: Decodable {
    public var code: Int
    public var data: T?
    public var msg: String

    init(code: Int,
         msg: String,
         data: T?) {
        self.code = code
        self.msg = msg
        self.data = data
    }

    public func isSuccess() -> Bool {
        return code == 200
    }
}

public struct DSError: Error {
    let code: Int
    let message: String
}

extension Network {
    public func path(_ param: String) -> String {
        return endPoint + param
    }
}

final class Network<T: Decodable> {
    private let endPoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    private let overTime = DispatchTimeInterval.seconds(5)

    init(_ endPoint: String) {
        self.endPoint = endPoint
        scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
    }

    func requestList(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]) -> Observable<[T]> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .json(method, absolutePath)
            .debug()
            .timeout(overTime, scheduler: scheduler)
            .map({ data -> [T] in
                if let result = NetworkData<[T]>.decodeJSON(from: data) {
                    if result.isSuccess() { return result.data ?? [] }
                    throw DSError(code: result.code, message: result.msg)
                }
                throw DSError(code: 2001, message: "服务异常，稍后再试")
            })
    }

    func requestModel(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .json(method, absolutePath)
            .debug()
            .observeOn(scheduler)
            .map({ data -> T in
                if let result = NetworkData<T>.decodeJSON(from: data) {
                    if result.isSuccess(), let model = result.data { return model }
                    throw DSError(code: result.code, message: result.msg)
                }
                throw DSError(code: 2001, message: "服务异常，稍后再试")
            })
    }
}
