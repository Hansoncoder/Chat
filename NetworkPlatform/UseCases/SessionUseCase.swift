//
//  SessionUseCase.swift
//  NetworkPlatform
//
//  Created by Hanson on 2021/5/28.
//

import Domain
import Foundation
import RxSwift

final class SessionUseCase: Domain.SessionUseCase {
    private lazy var sessionNet = networkProvider.makeNetwork(Session.self)

    func sessionList() -> Observable<[Session]> {
        return Observable.create { observer -> Disposable in
            let json: [String: Any] = [
                "image": "",
                "sessionName": "大学社团",
                "lastMessage": "在群里聊得很开心",
                "isTop": true,
                "isGroup": false]

            if let session = Session.decodeJSON(from: json) {
                var list: [Session] = []
                (0...10).forEach {_ in list.append(session) }
                observer.on(.next(list))
            } else {
                observer.onError(DSError(code: 2001, message: "解析失败"))
            }
            return Disposables.create()
        }
    }
}
