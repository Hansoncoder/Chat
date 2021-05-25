//
//  ChatMessageSender.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import UIKit
import Chatto

public protocol BaseMessageModelProtocol: MessageModelProtocol, ContentEquatableChatItemProtocol {
    var status: MessageStatus { get set }
}

public class ChatMessageSender {

    public var onMessageChanged: ((_ message: BaseMessageModelProtocol) -> Void)?

    public func sendMessages(_ messages: [BaseMessageModelProtocol]) {
        for message in messages {
            self.fakeMessageStatus(message)
        }
    }

    public func sendMessage(_ message: BaseMessageModelProtocol) {
        self.fakeMessageStatus(message)
    }

    private func fakeMessageStatus(_ message: BaseMessageModelProtocol) {
        switch message.status {
        case .success:
            break
        case .failed:
            self.updateMessage(message, status: .sending)
            self.fakeMessageStatus(message)
        case .sending:
            switch arc4random_uniform(100) % 5 {
            case 0:
                if arc4random_uniform(100) % 2 == 0 {
                    self.updateMessage(message, status: .failed)
                } else {
                    self.updateMessage(message, status: .success)
                }
            default:
                let delaySeconds: Double = Double(arc4random_uniform(1200)) / 1000.0
                let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.fakeMessageStatus(message)
                }
            }
        }
    }

    private func updateMessage(_ message: BaseMessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }

    private func notifyMessageChanged(_ message: BaseMessageModelProtocol) {
        self.onMessageChanged?(message)
    }
}
