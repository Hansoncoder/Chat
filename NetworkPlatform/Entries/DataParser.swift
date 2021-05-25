//
//  DataParser.swift
//  FanMile
//
//  Created by Hanson on 2020/3/13.
//  Copyright © 2020 Hanson. All rights reserved.
//

import Foundation
import Codextended
import SwiftyJSON
import Domain

let RESULT_CODE = "code"        //状态码
let RESULT_DATA = "data"        //数据段
let RESULT_MESSAGE = "message"  //错误消息提示
let SUCCESSCODE = 200 // 正确状态码

class DataParser<T: Domain.ECodable> {
    
    static func isSuccess(_ data:[String: Any]?) -> Bool {
        if let code = data?[RESULT_CODE] as? Int {
            if code == SUCCESSCODE {
                return true
            }
            errorHandling(code)
        }
        return false
    }
    
    static func execute(from data: Any?, print log: Bool = false) -> T? {
        if log {
            print("----------------------------- \(T.self)  -----------------------------\n")
            prettyPrint(data: data)
            print("\n----------------------------------------------------------------------")
        }
        
        return T.decodeJSON(from: data)
    }
    
    static func executeList(from data: Any?, print log: Bool = false) -> [T]? {
        if log {
            print("----------------------------- \(T.self)  -----------------------------\n")
            prettyPrint(data: data)
            print("\n----------------------------------------------------------------------")
        }
        
        return [T].decodeJSON(from: data)
    }
    
    private static func decode(data:Data) -> T? {
        let response = try? data.decoded() as T
        return response
    }
}

extension DataParser {
    static func prettyPrint(data: Any?) {
        guard let data = data else { return }
        
        #if DEBUG
        if let data = data as? Dictionary<String, Any> {
            print(data.json())
        } else {
            print(data)
        }
        #endif
    }
}

extension Encodable {
    
    func prettyJSON() -> String {
        let encode = JSONEncoder()
        encode.outputFormatting = .prettyPrinted
       
        guard let data = try?  self.encoded(using: encode),
            let output = String(data: data, encoding: .utf8)
            else { return "Error converting \(self) to JSON string" }
        return output
    }
    
    func prettyPrint() {
        #if DEBUG
         print(self.prettyJSON())
        #endif
    }
}

public extension Collection {
    
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}


//扩展Encodable协议,添加编码的方法
public extension Encodable {
    //1.遵守Codable协议的对象转json字符串
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    //2.对象转换成jsonObject
    func toJSONObject() -> Any? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
    //2.对象转换成jsonObject
    func toJSONDict() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
            return [:]
        }
        
        return dict
    }
    
    func toString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        if let data  = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
    
}

//扩展Decodable协议,添加解码的方法
public extension Decodable {
    //3.json字符串转对象&数组
    static func decodeJSON(from string: String?, designatedPath: String? = nil) -> Self? {
        
        guard let data = string?.data(using: .utf8),
            let jsonData = getInnerObject(inside: data, by: designatedPath) else {
                return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
    
    //4.jsonObject转换对象或者数组
    static func decodeJSON(from jsonObject: Any?, designatedPath: String? = nil) -> Self? {
        //        print(Date().milliStamp)
        
        guard let jsonObject = jsonObject,
            JSONSerialization.isValidJSONObject(jsonObject),
            
            let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
            
            let jsonData = getInnerObject(inside: data, by: designatedPath)  else {
                return nil
        }
        
        #if DEBUG
            return try? CleanJSONDecoder().decode(Self.self, from: jsonData)
        #else
            return try? CleanJSONDecoder().decode(Self.self, from: jsonData)
        #endif
        
    }
    
    //4.jsonObject转换对象或者数组
    static func ddecodeJSON(from jsonObject: Any?, designatedPath: String? = nil) -> Self? {
        //        print(Date().milliStamp)
        guard let jsonObject = jsonObject,
            JSONSerialization.isValidJSONObject(jsonObject),
            
            let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
            let jsonData = getInnerObject(inside: data, by: designatedPath)  else {
                return nil
        }
        //        print(Date().milliStamp)
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
}

//扩展Array,添加将jsonString或者jsonObject解码到对应对象数组的方法
public extension Array where Element: Codable {
    
    static func decodeJSON(from jsonString: String?, designatedPath: String? = nil) -> [Element?]? {
        guard let data = jsonString?.data(using: .utf8),
            let jsonData = getInnerObject(inside: data, by: designatedPath),
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Any] else {
                return nil
        }
        return Array.decodeJSON(from: jsonObject)
    }
    
    static func decodeJSON(from array: [Any]?) -> [Element?]? {
        return array?.map({ (item) -> Element? in
            return Element.decodeJSON(from: item)
        })
    }
}


/// 借鉴HandyJSON中方法，根据designatedPath获取object中数据
///
/// - Parameters:
///   - jsonData: json data
///   - designatedPath: 获取json object中指定路径
/// - Returns: 可能是json object
fileprivate func getInnerObject(inside jsonData: Data?, by designatedPath: String?) -> Data? {
    
    return jsonData
}


//MARK: - 处理数据
extension Dictionary {
    public func append(_ newValue: Dictionary) -> Dictionary {
        var temp = self
        for (key, value) in newValue {
            temp.updateValue(value, forKey: key)
        }
        return temp
    }
}

extension String: Domain.ECodable {
    
    public func toJSON() -> JSON? {
        guard let data = self.data(using: .utf8)  else {
            debugPrint("String转JSON失败！")
            return nil
        }
        return  try? JSON(data: data)
    }
    
    public func toJSONObject() -> Any? {
        return self.toJSON()?.toJSONObject()
    }
    
    public func toJSONDict() -> [String : Any] {
        return self.toJSON()?.toJSONDict() ?? [:]
    }
}

// MARK: - 本项目错误码 Code 业务处理，集成到其他项目，这部分代码请移除
extension DataParser {
    static func errorHandling(_ code: Int) {
//        switch code {
//        case 20001:
//            User.clean()
//        default:
//            break
//        }
    }
}


extension Data {
    
    func toText() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    func toDictionary() -> Dictionary<String, Any>? {
        if let data = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? Dictionary<String,Any> {
            return data
        }
        return nil
    }
    
    func toModel<T:ECodable>(type: T.Type) -> T? {
        guard let dic = self.toDictionary() else { return nil }
        guard let model = DataParser<T>.execute(from: dic["data"], print: true) else { return nil }
        return model
    }
    
    func toList<T:ECodable>(type: T.Type) -> [T]? {
        guard let dic = self.toDictionary() else { return nil }
        guard let model = DataParser<T>.executeList(from: dic["data"], print: true) else { return nil }
        return model
    }
}
