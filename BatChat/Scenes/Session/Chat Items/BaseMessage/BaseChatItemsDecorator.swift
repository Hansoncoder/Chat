//
//  BaseChatItemsDecorator.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import UIKit
import Chatto

final class BaseChatItemsDecorator: ChatItemsDecoratorProtocol {
    private struct Constants {
        static let shortSeparation: CGFloat = 3
        static let normalSeparation: CGFloat = 10
        static let timeIntervalThresholdToIncreaseSeparation: TimeInterval = 120
    }

    private let messagesSelector: MessagesSelectorProtocol
    init(messagesSelector: MessagesSelectorProtocol) {
        self.messagesSelector = messagesSelector
    }

    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        var decoratedChatItems = [DecoratedChatItem]()
        let calendar = Calendar.current

        for (index, chatItem) in chatItems.enumerated() {
            let next: ChatItemProtocol? = (index + 1 < chatItems.count) ? chatItems[index + 1] : nil
            let prev: ChatItemProtocol? = (index > 0) ? chatItems[index - 1] : nil

            let bottomMargin = self.separationAfterItem(chatItem, next: next)
            let showsTail = true
            var additionalItems =  [DecoratedChatItem]()
            var addTimeSeparator = false
            var isSelected = false
            var isShowingSelectionIndicator = false

            if let currentMessage = chatItem as? MessageModelProtocol {
//                if let nextMessage = next as? MessageModelProtocol {
//                    showsTail = currentMessage.senderId != nextMessage.senderId
//                } else {
//                    showsTail = true
//                }

                if let previousMessage = prev as? MessageModelProtocol {
                    addTimeSeparator = !calendar.isDate(currentMessage.date, inSameDayAs: previousMessage.date)
                } else {
                    addTimeSeparator = true
                }

                if addTimeSeparator {
                    let dateTimeStamp = DecoratedChatItem(chatItem: TimeSeparatorModel(uid: "\(currentMessage.uid)-time-separator", date: currentMessage.date.toWeekDayAndDateString()), decorationAttributes: nil)
                    decoratedChatItems.append(dateTimeStamp)
                }

                isSelected = self.messagesSelector.isMessageSelected(currentMessage)
                isShowingSelectionIndicator = self.messagesSelector.isActive && self.messagesSelector.canSelectMessage(currentMessage)
            }

            let messageDecorationAttributes = BaseMessageDecorationAttributes(
                canShowFailedIcon: true,
                isShowingTail: showsTail,
                isShowingAvatar: showsTail,
                isShowingSelectionIndicator: isShowingSelectionIndicator,
                isSelected: isSelected,
                isShowReadTip: true
            )

            decoratedChatItems.append(
                DecoratedChatItem(
                    chatItem: chatItem,
                    decorationAttributes: ChatItemDecorationAttributes(bottomMargin: bottomMargin, messageDecorationAttributes: messageDecorationAttributes)
                )
            )
            decoratedChatItems.append(contentsOf: additionalItems)
        }

        return decoratedChatItems
    }

    private func separationAfterItem(_ current: ChatItemProtocol?, next: ChatItemProtocol?) -> CGFloat {
        guard let nexItem = next else { return 0 }
        guard let currentMessage = current as? MessageModelProtocol else { return Constants.normalSeparation }
        guard let nextMessage = nexItem as? MessageModelProtocol else { return Constants.normalSeparation }

        if currentMessage.senderId != nextMessage.senderId {
            return Constants.normalSeparation
        } else if nextMessage.date.timeIntervalSince(currentMessage.date) > Constants.timeIntervalThresholdToIncreaseSeparation {
            return Constants.normalSeparation
        } else {
            return Constants.shortSeparation
        }
    }
}
