//
//  BaseMessagesSelector.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import Foundation
import Chatto

public class BaseMessagesSelector: MessagesSelectorProtocol {

    public weak var delegate: MessagesSelectorDelegate?

    public var isActive = false {
        didSet {
            guard oldValue != self.isActive else { return }
            if self.isActive {
                self.selectedMessagesDictionary.removeAll()
            }
        }
    }

    public func canSelectMessage(_ message: MessageModelProtocol) -> Bool {
        return true
    }

    public func isMessageSelected(_ message: MessageModelProtocol) -> Bool {
        return self.selectedMessagesDictionary[message.uid] != nil
    }

    public func selectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = message
        self.delegate?.messagesSelector(self, didSelectMessage: message)
    }

    public func deselectMessage(_ message: MessageModelProtocol) {
        self.selectedMessagesDictionary[message.uid] = nil
        self.delegate?.messagesSelector(self, didDeselectMessage: message)
    }

    public func selectedMessages() -> [MessageModelProtocol] {
        return Array(self.selectedMessagesDictionary.values)
    }

    // MARK: - Private

    private var selectedMessagesDictionary = [String: MessageModelProtocol]()
}
