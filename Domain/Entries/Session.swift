//
//  Session.swift
//  Domain
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

public struct Session: ECodable {
    public let sessionName: String?
    public let lastMessage: String?
}
