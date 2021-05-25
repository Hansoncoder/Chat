//
//  ECodable.swift
//  Domain
//
//  Created by Hanson on 2020/11/3.
//  Copyright © 2020 Hanson. All rights reserved.
//

import Foundation

public protocol ECodable: Codable {
    mutating func didFinishMapping()
    func toDic() -> [String:Any]
}

extension ECodable {
    public mutating func didFinishMapping() {}
    public func toDic() -> [String:Any] {
        return [String:Any]()
    }
}
