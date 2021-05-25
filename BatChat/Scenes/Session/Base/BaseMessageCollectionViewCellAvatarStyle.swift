//
//  BaseMessageCollectionViewCellAvatarStyle.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import UIKit

class BaseMessageCollectionViewCellAvatarStyle: BaseMessageCollectionViewCellDefaultStyle {

    init() {
        super.init(
            replyIndicatorStyle: .init(
                image: UIImage(named: "reply-indicator")!,
                size: .init(width: 38, height: 38),
                maxOffsetToReplyIndicator: 48
            )
        )
    }

    override func avatarSize(viewModel: MessageViewModelProtocol) -> CGSize {
        // Display avatar for both incoming and outgoing messages for demo purpose
        return CGSize(width: 35, height: 35)
    }
}
