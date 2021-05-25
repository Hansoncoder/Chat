//
//  BaseMessageCollectionViewCellAvatarStyle.swift
//  BatChat
//
//  Created by Hanson on 2021/2/23.
//

import UIKit

class BaseMessageCollectionViewCellAvatarStyle: BaseMessageCollectionViewCellDefaultStyle {

    init() {
        super.init( dateTextStyle: .init(font: UIFont.systemFont(ofSize: 12), color: .red), replyIndicatorStyle: .none)
    }

    override func avatarSize(viewModel: MessageViewModelProtocol) -> CGSize {
        // Display avatar for both incoming and outgoing messages for demo purpose
        return CGSize(width: 35, height: 35)
    }
    
    override func avatarVerticalAlignment(viewModel: MessageViewModelProtocol) -> VerticalAlignment {
        return .top
    }
}
