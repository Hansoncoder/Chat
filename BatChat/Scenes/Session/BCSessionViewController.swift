//
//  BCSessionViewController.swift
//  BatChat
//
//  Created by Hanson on 2021/2/5.
//

import UIKit
import Chatto

class BCSessionViewController: BCChatViewController, NavigationProtocol {
    
    lazy var navBar: EFNavigationBar = setupNavBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        
        /// 隐藏导航栏，调整内容布局
        let inset = UIEdgeInsets(
            top: navBottom, left: 0,
            bottom: 0, right: 0)
        layoutConfiguration = ChatLayoutConfiguration(
            contentInsets: inset,
            scrollIndicatorInsets: .zero)
    }

    private func setupNav() {
        let statuText = "在线"
        let text = "张三 \(statuText)".attrText(
            .pingfangMedium(16),
            color: .blackText)
        text.update(
            color: .grayText,
            font: .pingfang(13),
            text: statuText)
        navBar.titleLabel.attributedText = text
        
        let imageView = UIImageView(image: "user_avatar".image)
        imageView.layer.cornerRadius = 18
        imageView.size = CGSize(width: 36, height: 36)
        imageView.right = screenW - 20
        imageView.centerY = navHeight * 0.5 + statusBarHeight
        navBar.addSubview(imageView)
        
        imageView.addClick(on: self) { (self) in
            self.addRandomMessage()
        }
    }
    
    
    @objc
    private func addRandomMessage() {
        self.dataSource.addRandomIncomingMessage()
    }

    @objc
    private func removeRandomMessage() {
        self.dataSource.removeRandomMessage()
    }
    
}

class BCChatViewController: BaseChatViewController {
    var shouldUseAlternativePresenter: Bool = false

    let viewModel = BCSessionViewModel()
    var inputTextView: ChatInputBar?
    let messagesSelector = BaseMessagesSelector()
    lazy var messageSender: ChatMessageSender = {
        return self.dataSource.messageSender
    }()
    
    lazy var dataSource: ChatDataSource = {
        let dataSource = ChatDataSource(count: 2, pageSize: 100)
        self.chatDataSource = dataSource
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cellPanGestureHandlerConfig.allowReplyRevealing = true

        self.title = "Chat"
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = BaseChatItemsDecorator(messagesSelector: self.messagesSelector)
        view.backgroundColor = .backColor
//        self.replyActionHandler = DemoReplyActionHandler(presentingViewController: self)
    }

    var chatInputPresenter: AnyObject!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        self.inputTextView = chatInputView
        let appearance = ChatInputBarAppearance()
        if self.shouldUseAlternativePresenter {
            let chatInputPresenter = ExpandableChatInputBarPresenter(
                inputPositionController: self,
                chatInputBar: chatInputView,
                chatInputItems: self.createChatInputItems(),
                chatInputBarAppearance: appearance)
            self.chatInputPresenter = chatInputPresenter
            self.keyboardEventsHandler = chatInputPresenter
            self.scrollViewEventsHandler = chatInputPresenter
        } else {
            self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        }
        chatInputView.maxCharactersCount = 300
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {

        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: self.createTextMessageViewModelBuilder(),
            interactionHandler: MessageInteractionHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()

        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: ChatPhotoMessageViewModelBuilder(),
            interactionHandler: MessageInteractionHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
//
//        let compoundPresenterBuilder = CompoundMessagePresenterBuilder(
//            viewModelBuilder: DemoCompoundMessageViewModelBuilder(),
//            interactionHandler: DemoMessageInteractionHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector),
//            accessibilityIdentifier: nil,
//            contentFactories: [
//                .init(DemoTextMessageContentFactory()),
//                .init(DemoImageMessageContentFactory()),
//                .init(DemoDateMessageContentFactory())
//            ],
//            decorationFactories: [
//                .init(DemoEmojiDecorationViewFactory())
//            ],
//            baseCellStyle: BaseMessageCollectionViewCellAvatarStyle()
//        )
//
//        let compoundPresenterBuilder2 = CompoundMessagePresenterBuilder(
//            viewModelBuilder: DemoCompoundMessageViewModelBuilder(),
//            interactionHandler: DemoMessageInteractionHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector),
//            accessibilityIdentifier: nil,
//            contentFactories: [
//                .init(DemoTextMessageContentFactory()),
//                .init(DemoImageMessageContentFactory()),
//                .init(DemoInvisibleSplitterFactory()),
//                .init(DemoText2MessageContentFactory())
//            ],
//            decorationFactories: [
//                .init(DemoEmojiDecorationViewFactory())
//            ],
//            baseCellStyle: BaseMessageCollectionViewCellAvatarStyle()
//        )

        return [
            ChatTextMessageModel.chatItemType: [textMessagePresenter],
            ChatPhotoMessageModel.chatItemType: [photoMessagePresenter],
//            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
//            ChatItemType.compoundItemType: [compoundPresenterBuilder],
//            ChatItemType.compoundItemType2: [compoundPresenterBuilder2]
        ]
    }

    func createTextMessageViewModelBuilder() -> ChatTextMessageViewModelBuilder {
        return ChatTextMessageViewModelBuilder()
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
//        items.append(self.createEmojiInputItem())
//        if self.shouldUseAlternativePresenter {
//            items.append(self.customInputItem())
//        }
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image, _ in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }
    
//    private func createEmojiInputItem() -> EmojiChatInputItem {
//        let item = EmojiChatInputItem(presentingController: self)
//        if let textView = self.inputTextView {
//            item.delegate = textView
//        }
//        return item
//    }

//    private func customInputItem() -> ContentAwareInputItem {
//        let item = ContentAwareInputItem()
//        item.textInputHandler = { [weak self] text in
//            self?.dataSource.addTextMessage(text)
//        }
//        return item
//    }
}

extension BCChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}
