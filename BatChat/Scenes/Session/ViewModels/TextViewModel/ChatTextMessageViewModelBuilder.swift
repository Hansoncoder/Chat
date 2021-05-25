//
//  TextMessageViewModelBuilder.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import UIKit


public typealias ChatTextMessageViewModel = TextMessageViewModel<ChatTextMessageModel>

public class ChatTextMessageViewModelBuilder: ViewModelBuilderProtocol {

    typealias ObservableImageProvider = (ChatTextMessageModel) -> Observable<UIImage?>

    private static let defaultObservableImageProvider: ObservableImageProvider = { _ in Observable<UIImage?>.just(UIImage(named: "user_avatar")) }

    private let imageProvider: ObservableImageProvider

    init(imageProvider: @escaping ObservableImageProvider = ChatTextMessageViewModelBuilder.defaultObservableImageProvider) {
        self.imageProvider = imageProvider
    }

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    public func createViewModel(_ textMessage: ChatTextMessageModel) -> ChatTextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
        let textMessageViewModel = ChatTextMessageViewModel(textMessage: textMessage, messageViewModel: messageViewModel)
        textMessageViewModel.avatarImage = self.imageProvider(textMessage)
        return textMessageViewModel
    }

    public func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is ChatTextMessageModel
    }
}
