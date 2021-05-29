//
//  SessionUseCase.swift
//  Domain
//
//  Created by Hanson on 2021/5/28.
//

import RxSwift

public protocol SessionUseCase {
    func sessionList() -> Observable<[Session]>
}
