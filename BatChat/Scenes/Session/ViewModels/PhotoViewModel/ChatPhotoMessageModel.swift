//
//  ChatPhotoMessageModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/22.
//

import UIKit

public class ChatPhotoMessageModel: PhotoMessageModel<MessageModel>, BaseMessageModelProtocol {
    public override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
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

