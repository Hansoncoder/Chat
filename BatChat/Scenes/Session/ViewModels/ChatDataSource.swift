//
//  ChatDataSource.swift
//  BatChat
//
//  Created by Hanson on 2021/2/21.
//

import UIKit
import Chatto

class ChatDataSource: ChatDataSourceProtocol {
    var nextMessageId: Int = 0
    let preferredMaxWindowSize = 500

    var slidingWindow: SlidingDataSource<ChatItemProtocol>!
    init(count: Int, pageSize: Int) {
        self.slidingWindow = SlidingDataSource(count: count, pageSize: pageSize) { [weak self] () -> ChatItemProtocol in
            guard let sSelf = self else { return ChatMessageFactory.makeRandomMessage("") }
            defer { sSelf.nextMessageId += 1 }
            return ChatMessageFactory.makeRandomMessage("\(sSelf.nextMessageId)")
        }
    }

    init(messages: [ChatItemProtocol], pageSize: Int) {
        self.slidingWindow = SlidingDataSource(items: messages, pageSize: pageSize)
    }

    lazy var messageSender: ChatMessageSender = {
        let sender = ChatMessageSender()
        sender.onMessageChanged = { [weak self] (message) in
            guard let sSelf = self else { return }
            sSelf.delegate?.chatDataSourceDidUpdate(sSelf)
        }
        return sender
    }()

    var hasMoreNext: Bool {
        return self.slidingWindow.hasMore()
    }

    var hasMorePrevious: Bool {
        return self.slidingWindow.hasPrevious()
    }

    var chatItems: [ChatItemProtocol] {
        return self.slidingWindow.itemsInWindow
    }

    weak var delegate: ChatDataSourceDelegateProtocol?

    func loadNext() {
        self.slidingWindow.loadNext()
        self.slidingWindow.adjustWindow(focusPosition: 1, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }

    func loadPrevious() {
        self.slidingWindow.loadPrevious()
        self.slidingWindow.adjustWindow(focusPosition: 0, maxWindowSize: self.preferredMaxWindowSize)
        self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
    }

    func addTextMessage(_ text: String) {
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = ChatMessageFactory.makeTextMessage(uid, text: text, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }

    func addPhotoMessage(_ image: UIImage) {
        let uid = "\(self.nextMessageId)"
        self.nextMessageId += 1
        let message = ChatMessageFactory.makePhotoMessage(uid, image: image, size: image.size, isIncoming: false)
        self.messageSender.sendMessage(message)
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func addRandomIncomingMessage() {
        let message = ChatMessageFactory.makeRandomMessage("\(self.nextMessageId)", isIncoming: true)
        self.nextMessageId += 1
        self.slidingWindow.insertItem(message, position: .bottom)
        self.delegate?.chatDataSourceDidUpdate(self)
    }

    func removeRandomMessage() {
        self.slidingWindow.removeRandomItem()
        self.delegate?.chatDataSourceDidUpdate(self)
    }

    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion:(_ didAdjust: Bool) -> Void) {
        let didAdjust = self.slidingWindow.adjustWindow(focusPosition: focusPosition, maxWindowSize: preferredMaxCount ?? self.preferredMaxWindowSize)
        completion(didAdjust)
    }

    func replaceMessage(withUID uid: String, withNewMessage newMessage: ChatItemProtocol) {
        let didUpdate = self.slidingWindow.replaceItem(withNewItem: newMessage) { $0.uid == uid }
        guard didUpdate else { return }
        self.delegate?.chatDataSourceDidUpdate(self)
    }
}
