//
//  SessionListCellVM.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import Domain
import UIKit

enum SessionType: Int {
    case `private` = 0
    case group = 1
    case system = 2
}

final class SessionListCellVM {
    let name: String?
    let message: String?
    let iconURL: String?
    var unreadCount: String?
    var isTop: Bool = false
    var isDisturb: Bool = true
    var type: SessionType = .private

    init(with session: Session) {
        let randomCount = arc4random() % 200
        
        type = SessionType(rawValue: Int(randomCount % 3)) ?? .private
        unreadCount = (randomCount >= 100) ? nil : "\(randomCount)"
        iconURL = "user_avatar"
        switch type {
        case .system:
            name = "群通知"
            unreadCount = ""
            message = "\"大伙\"已经将你移除群聊"
        case .private:
            name = "张三"
            message = "很高兴认识你！"
            
        default:
            name = session.sessionName
            message = session.lastMessage
        }
    }
}
