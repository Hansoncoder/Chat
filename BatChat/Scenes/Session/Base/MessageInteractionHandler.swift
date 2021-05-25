//
//  MessageInteractionHandler.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import Foundation

final class MessageInteractionHandler<Model: BaseMessageModelProtocol, ViewModel: MessageViewModelProtocol>: BaseMessageInteractionHandlerProtocol {

    init(messageSender: ChatMessageSender, messagesSelector: MessagesSelectorProtocol) {
        self.messageSender = messageSender
        self.messagesSelector = messagesSelector
    }

    private let messageSender: ChatMessageSender
    private let messagesSelector: MessagesSelectorProtocol

    func userDidTapOnFailIcon(message: Model, viewModel: ViewModel, failIconView: UIView) {
        print(#function)
        self.messageSender.sendMessage(message)
    }

    func userDidTapOnAvatar(message: Model, viewModel: ViewModel) {
        print(#function)
    }

    func userDidTapOnBubble(message: Model, viewModel: ViewModel) {
        if let message = message as? PhotoMessageModel<MessageModel> {
            showImage(image: message.image)
        }
        print(#function)
    }

    func userDidDoubleTapOnBubble(message: Model, viewModel: ViewModel) {
        print(#function)
    }

    func userDidBeginLongPressOnBubble(message: Model, viewModel: ViewModel) {
        print(#function)
    }

    func userDidEndLongPressOnBubble(message: Model, viewModel: ViewModel) {
        print(#function)
    }

    func userDidSelectMessage(message: Model, viewModel: ViewModel) {
        print(#function)
        self.messagesSelector.selectMessage(message)
    }

    func userDidDeselectMessage(message: Model, viewModel: ViewModel) {
        print(#function)
        self.messagesSelector.deselectMessage(message)
    }
}
