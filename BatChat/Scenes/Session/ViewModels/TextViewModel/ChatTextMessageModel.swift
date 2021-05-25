//
//  ChatTextMessageModel.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import UIKit
import Chatto

public class ChatTextMessageModel: TextMessageModel<MessageModel>, BaseMessageModelProtocol {
    public override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }

    public var status: MessageStatus {
        get {
            return self._messageModel.status
        }
        set {
            self._messageModel.status = newValue
        }
    }
}
