//
//  EmojiChatInputItem.swift
//  BatChat
//
//  Created by Hanson on 2021/2/25.
//

import UIKit

open class EmojiChatInputItem: NSObject, ChatInputItemProtocol {
    weak var delegate: EmojiInputViewProtocol? {
        didSet {
            if let view = inputView as? EmojiContainView {
                view.delegate = delegate
            }
        }
    }
    public var textInputHandler: ((String) -> Void)?
    public private(set) var supportsExpandableState: Bool = false
    public private(set) var expandedStateTopMargin: CGFloat = 0.0

    typealias Class = EmojiChatInputItem

    let buttonAppearance: TabInputButtonAppearance
    public init(tabInputButtonAppearance: TabInputButtonAppearance = EmojiChatInputItem.createDefaultButtonAppearance()) {
        buttonAppearance = tabInputButtonAppearance
    }

    public static func createDefaultButtonAppearance() -> TabInputButtonAppearance {
        let images: [UIControlStateWrapper: UIImage] = [
            UIControlStateWrapper(state: .normal): UIImage(named: "emoji-icon-unselected", in: Bundle.resources, compatibleWith: nil)!,
            UIControlStateWrapper(state: .selected): UIImage(named: "emoji-icon-selected", in: Bundle.resources, compatibleWith: nil)!,
            UIControlStateWrapper(state: .highlighted): UIImage(named: "emoji-icon-selected", in: Bundle.resources, compatibleWith: nil)!,
        ]
        return TabInputButtonAppearance(images: images, size: nil)
    }

    private lazy var internalTabView: UIButton = {
        TabInputButton.makeInputButton(withAppearance: self.buttonAppearance, accessibilityID: "emoji.chat.input.view")
    }()

    open var selected = false {
        didSet {
            self.internalTabView.isSelected = self.selected
        }
    }

    // MARK: - ChatInputItemProtocol

    open var presentationMode: ChatInputItemPresentationMode {
        return .customView
    }

    open var showsSendButton: Bool {
        return true
    }

    open var showsTextView: Bool {
        return true
    }

    public var inputViewHeight: CGFloat {
        return 240
    }

    open var inputView: UIView? {
        let frame = CGRect(x: 0, y: 0, width: screenW, height: inputViewHeight)
        let emojiView = EmojiContainView(frame: frame)
        emojiView.delegate = self.delegate
        return emojiView
    }

    open var tabView: UIView {
        return self.internalTabView
    }

    open func handleInput(_ input: AnyObject) {
        if let text = input as? String, text.count > 0 {
            self.textInputHandler?(text)
        }
    }

    open var shouldSaveDraftMessage: Bool {
        return false
    }
}
