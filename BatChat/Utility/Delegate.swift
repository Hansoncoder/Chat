//
//  Delegate.swift
//  BatChat
//
//  Created by Hanson on 2021/5/29.
//

import UIKit

class Delegate<Input, Output> {
    private var block: ((Input) -> Output?)?
    func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
        self.block = { [weak target] input in
            guard let target = target else { return nil }
            return block?(target, input)
        }
    }
    
    func callAsFunction(_ input: Input) -> Output? {
        return block?(input)
    }
}

//MARK: - Output 是Optional 解包处理
public protocol OptionalProtocol {
    static var createNil: Self { get }
}

extension Optional : OptionalProtocol {
    public static var createNil: Optional<Wrapped> {
         return nil
    }
}

extension Delegate where Output: OptionalProtocol {
    func callAsFunction(_ input: Input) -> Output {
        if let result = block?(input) {
            return result
        } else {
            return .createNil
        }
    }
}
