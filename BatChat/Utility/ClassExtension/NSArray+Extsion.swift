//
//  NSArray+Extsion.swift
//  forum
//
//  Created by Hanson on 2020/12/13.
//  Copyright © 2020 Hanson. All rights reserved.
//

import UIKit

extension Array where Element:Hashable {
    // 数组去重
    var unique:[Element] {
        var uniq = Set<Element>()
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
    
    func getIndex(of object:Element) -> Int {
        return self.firstIndex(of: object) ?? NSNotFound
    }
}

extension Array where Element == Int {
    func replaceUnderOneWith(str:String) -> [String]{
       var nList = [String]()
       for item in self {
           if item == -1 {
               nList.append(str)
           }else{
                nList.append("\(item)")
           }
       }
       return nList
    }
}


extension Array where Element : Any {
    //列表转Map
    func toAnyMap(key:String) -> [String:Any] {
        var map = [String:Any]()
        for item in self {
            if let dic = item as? [String:Any] {
                let id = dic.valueAsInt(for: "id", for: 0)
//                if let id = dic["id"] as? Int {
                    map["\(id)"] = dic
//                }
            }
        }
        return map
    }
    
    func toBoolMap(key:String?) -> [String:Bool] {
        var map = [String:Bool]()
        for item in self {
            if let dic = item as? [String:Any] {
                if let value = dic[key ?? "-"] as? Int {
                    map["\(value)"] = true
                }
            }
            else if let value = item as? String {
                map[value] = true
            }
        }
        return map
    }
    
    func toIntBoolMap() -> [Int:Bool] {
        var map = [Int:Bool]()
        for item in self {
            if let value = item as? Int {
                map[value] = true
            }
        }
        return map
    }
    
    
    func toIntIntMap() -> [Int:Int] {
        var map = [Int:Int]()
        var index = 0
        if let list = self as? [Int] {
            for item in list {
                map[index] = item
                index = index+1
            }
        }
        return map
    }
    
    func toValues(key:String) -> [String] {
        var values = [String]()
        for item in self {
            if let dic = item as? [String:Any] {
//                if let value = dic.valueAsInt(for: key) {
//                    values.append("\(value)")
//                }
                values.append("\(dic.valueAsInt(for: key))")
            }
        }
        
        return values
    }
}

public extension Sequence {
    func group<Key>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] where Key: Hashable {
        return Dictionary(grouping: self, by: {
            $0[keyPath: keyPath]
        })
    }
}
