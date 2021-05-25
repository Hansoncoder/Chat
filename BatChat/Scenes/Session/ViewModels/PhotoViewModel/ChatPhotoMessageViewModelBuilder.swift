//
//  ChatPhotoMessageViewModelBuilder.swift
//  BatChat
//
//  Created by Hanson on 2021/5/22.
//

import UIKit

class ChatPhotoMessageViewModel: PhotoMessageViewModel<ChatPhotoMessageModel> {

    let fakeImage: UIImage
    override init(photoMessage: ChatPhotoMessageModel, messageViewModel: MessageViewModelProtocol) {
        self.fakeImage = photoMessage.image
        super.init(photoMessage: photoMessage, messageViewModel: messageViewModel)
//        if photoMessage.isIncoming {
//            self.image.value = nil
//        }
    }

    override func willBeShown() {
        self.fakeProgress()
    }

    func fakeProgress() {
//        if [TransferStatus.success, TransferStatus.failed].contains(self.transferStatus.value) {
//            return
//        }
//        if self.transferProgress.value >= 1.0 {
//            if arc4random_uniform(100) % 2 == 0 {
//                self.transferStatus.value = .success
//                self.image.value = self.fakeImage
//            } else {
//                self.transferStatus.value = .failed
//            }
//
//            return
//        }
//        self.transferStatus.value = .transfering
//        let delaySeconds: Double = Double(arc4random_uniform(600)) / 1000.0
//        let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
//            guard let sSelf = self else { return }
//            let deltaProgress = Double(arc4random_uniform(15)) / 100.0
//            sSelf.transferProgress.value = min(sSelf.transferProgress.value + deltaProgress, 1)
//            sSelf.fakeProgress()
//        }
    }
}

class ChatPhotoMessageViewModelBuilder: ViewModelBuilderProtocol {

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    func createViewModel(_ model: ChatPhotoMessageModel) -> ChatPhotoMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let photoMessageViewModel = ChatPhotoMessageViewModel(photoMessage: model, messageViewModel: messageViewModel)
        photoMessageViewModel.avatarImage = Observable<UIImage?>.just(UIImage(named: "user_avatar"))
        return photoMessageViewModel
    }

    func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is ChatPhotoMessageModel
    }
}
