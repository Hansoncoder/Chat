//
//  Dictionary+Extension.swift
//  forum
//
//  Created by Hanson on 2020/12/14.
//  Copyright © 2020 Hanson. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func value(for key: Key, orAdd valueClosure: @autoclosure () -> Value) -> Value {
        if let value = self[key] {
            return value
        }
        
        let value = valueClosure()
        self[key] = value
        return value
    }
    
    func isValueValid(key:Key) -> Bool {
        let obj = self[key]
        if let str = obj as? String {
            return str.count > 0
        }
        if let str = obj as? [String:Any] {
            return str.count > 0
        }
        return obj != nil
    }
}

extension Dictionary where Key == String {
    func value<V>(for key: Key,
                  default defaultExpression: @autoclosure () -> V) -> V {
        return (self[key] as? V) ?? defaultExpression()
    }
    
    func valueAsInt(for key:String, for retInt:Int=0) -> Int {
        if let obj = self[key] as? Int {
            return obj
        }
        if let obj = self[key] as? String {
            return Int(obj) ?? retInt
        }
        return 0
    }
    
    func valueAsInt(key:String) ->Int?{
        if let obj = self[key] as? Int {
            return obj
        }
        
        if let obj = self[key] as? String {
            return Int(obj)
        }
        
        return nil
    }
    
    func valueAsInt64(key:String) ->Int64?{
        if let obj = self[key] as? Int64 {
            return obj
        }
        
        if let obj = self[key] as? String {
            return Int64(obj)
        }
        
        return nil
    }
}
