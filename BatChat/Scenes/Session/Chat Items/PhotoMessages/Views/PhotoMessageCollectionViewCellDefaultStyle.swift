/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

open class PhotoMessageCollectionViewCellDefaultStyle: PhotoMessageCollectionViewCellStyleProtocol {
    
    typealias Class = PhotoMessageCollectionViewCellDefaultStyle

    public struct BubbleMasks {
        public let incomingTail: () -> UIImage
        public let incomingNoTail: () -> UIImage
        public let outgoingTail: () -> UIImage
        public let outgoingNoTail: () -> UIImage
        public let tailWidth: CGFloat
        public init(
            incomingTail: @autoclosure @escaping () -> UIImage,
            incomingNoTail: @autoclosure @escaping () -> UIImage,
            outgoingTail: @autoclosure @escaping () -> UIImage,
            outgoingNoTail: @autoclosure @escaping () -> UIImage,
            tailWidth: CGFloat) {
            self.incomingTail = incomingTail
            self.incomingNoTail = incomingNoTail
            self.outgoingTail = outgoingTail
            self.outgoingNoTail = outgoingNoTail
            self.tailWidth = tailWidth
        }
    }

    public struct Sizes {
        public let aspectRatioIntervalForSquaredSize: ClosedRange<CGFloat>
        public let photoSizeLandscape: CGSize
        public let photoSizePortrait: CGSize
        public let photoSizeSquare: CGSize
        public init(
            aspectRatioIntervalForSquaredSize: ClosedRange<CGFloat>,
            photoSizeLandscape: CGSize,
            photoSizePortrait: CGSize,
            photoSizeSquare: CGSize) {
            self.aspectRatioIntervalForSquaredSize = aspectRatioIntervalForSquaredSize
            self.photoSizeLandscape = photoSizeLandscape
            self.photoSizePortrait = photoSizePortrait
            self.photoSizeSquare = photoSizeSquare
        }
    }

    public struct Colors {
        public let placeholderIconTintIncoming: UIColor
        public let placeholderIconTintOutgoing: UIColor
        public let progressIndicatorColorIncoming: UIColor
        public let progressIndicatorColorOutgoing: UIColor
        public let overlayColor: UIColor
        public init(
            placeholderIconTintIncoming: UIColor,
            placeholderIconTintOutgoing: UIColor,
            progressIndicatorColorIncoming: UIColor,
            progressIndicatorColorOutgoing: UIColor,
            overlayColor: UIColor) {
            self.placeholderIconTintIncoming = placeholderIconTintIncoming
            self.placeholderIconTintOutgoing = placeholderIconTintOutgoing
            self.progressIndicatorColorIncoming = progressIndicatorColorIncoming
            self.progressIndicatorColorOutgoing = progressIndicatorColorOutgoing
            self.overlayColor = overlayColor
        }
    }

    let bubbleMasks: BubbleMasks
    let sizes: Sizes
    let pandding: UIEdgeInsets
    let colors: Colors
    let baseStyle: BaseMessageCollectionViewCellDefaultStyle
    public init(
        bubbleMasks: BubbleMasks = PhotoMessageCollectionViewCellDefaultStyle.createDefaultBubbleMasks(),
        sizes: Sizes = PhotoMessageCollectionViewCellDefaultStyle.createDefaultSizes(),
        pandding: UIEdgeInsets = PhotoMessageCollectionViewCellDefaultStyle.createDefaultPandding(),
        colors: Colors = PhotoMessageCollectionViewCellDefaultStyle.createDefaultColors(),
        baseStyle: BaseMessageCollectionViewCellDefaultStyle = BaseMessageCollectionViewCellDefaultStyle()) {
        self.bubbleMasks = bubbleMasks
        self.sizes = sizes
        self.colors = colors
        self.baseStyle = baseStyle
        self.pandding = pandding
    }

    private lazy var maskImageIncomingTail: UIImage = self.bubbleMasks.incomingTail()
    private lazy var maskImageIncomingNoTail: UIImage = self.bubbleMasks.incomingNoTail()
    private lazy var maskImageOutgoingTail: UIImage = self.bubbleMasks.outgoingTail()
    private lazy var maskImageOutgoingNoTail: UIImage = self.bubbleMasks.outgoingNoTail()

    private lazy var placeholderBackgroundIncoming: UIImage = {
        UIImage.bma_imageWithColor(self.baseStyle.baseColorIncoming, size: CGSize(width: 1, height: 1))
    }()

    private lazy var placeholderBackgroundOutgoing: UIImage = {
        UIImage.bma_imageWithColor(self.baseStyle.baseColorOutgoing, size: CGSize(width: 1, height: 1))
    }()

    private lazy var placeholderIcon: UIImage = {
        UIImage(named: "photo-bubble-placeholder-icon", in: Bundle.resources, compatibleWith: nil)!
    }()

    open func maskingImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage {
        switch (viewModel.isIncoming, viewModel.decorationAttributes.isShowingTail) {
        case (true, true):
            return maskImageIncomingTail
        case (true, false):
            return maskImageIncomingNoTail
        case (false, true):
            return maskImageOutgoingTail
        case (false, false):
            return maskImageOutgoingNoTail
        }
    }

    open func borderImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage? {
        return baseStyle.borderImage(viewModel: viewModel)
    }

    open func placeholderBackgroundImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage {
        return viewModel.isIncoming ? placeholderBackgroundIncoming : placeholderBackgroundOutgoing
    }

    open func placeholderIconImage(viewModel: PhotoMessageViewModelProtocol) -> UIImage {
        return placeholderIcon
    }

    open func placeholderIconTintColor(viewModel: PhotoMessageViewModelProtocol) -> UIColor {
        return viewModel.isIncoming ? colors.placeholderIconTintIncoming : colors.placeholderIconTintOutgoing
    }

    open func tailWidth(viewModel: PhotoMessageViewModelProtocol) -> CGFloat {
        return bubbleMasks.tailWidth
    }

    open func photoSize(viewModel: PhotoMessageViewModelProtocol) -> CGSize {
        let aspectRatio = viewModel.imageSize.height > 0 ? viewModel.imageSize.width / viewModel.imageSize.height : 0

        if aspectRatio == 0 || self.sizes.aspectRatioIntervalForSquaredSize.contains(aspectRatio) {
            return self.sizes.photoSizeSquare
        } else if aspectRatio < self.sizes.aspectRatioIntervalForSquaredSize.lowerBound {
            return self.sizes.photoSizePortrait
        } else {
            return self.sizes.photoSizeLandscape
        }
    }
    
    
    open func bubbleSize(viewModel: PhotoMessageViewModelProtocol) -> CGSize {
        let tempSize = photoSize(viewModel: viewModel)
        let widht = tempSize.width + pandding.left + pandding.right
        let height = tempSize.height + pandding.top + pandding.bottom
        return CGSize(width: widht, height: height)
    }
    
    open func bubblePandding(viewModel: PhotoMessageViewModelProtocol) -> UIEdgeInsets {
        return pandding
    }

    open func progressIndicatorColor(viewModel: PhotoMessageViewModelProtocol) -> UIColor {
        return viewModel.isIncoming ? colors.progressIndicatorColorIncoming : colors.progressIndicatorColorOutgoing
    }

    open func overlayColor(viewModel: PhotoMessageViewModelProtocol) -> UIColor? {
//        let showsOverlay = viewModel.image.value != nil && (viewModel.transferStatus.value == .transfering || viewModel.status != MessageViewModelStatus.success)
//        return showsOverlay ? self.colors.overlayColor : nil
        return nil
    }
}

public extension PhotoMessageCollectionViewCellDefaultStyle { // Default values
    static func createDefaultBubbleMasks() -> BubbleMasks {
        return BubbleMasks(
            incomingTail: UIImage(named: "bubble-incoming", in: Bundle.resources, compatibleWith: nil)!,
            incomingNoTail: UIImage(named: "bubble-incoming", in: Bundle.resources, compatibleWith: nil)!,
            outgoingTail: UIImage(named: "bubble-outgoing", in: Bundle.resources, compatibleWith: nil)!,
            outgoingNoTail: UIImage(named: "bubble-outgoing", in: Bundle.resources, compatibleWith: nil)!,
            tailWidth: 6
        )
    }

    static func createDefaultSizes() -> Sizes {
        return Sizes(
            aspectRatioIntervalForSquaredSize: 0.90 ... 1.10,
            photoSizeLandscape: CGSize(width: 210, height: 136),
            photoSizePortrait: CGSize(width: 136, height: 210),
            photoSizeSquare: CGSize(width: 210, height: 210)
        )
    }

    static func createDefaultPandding() -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    static func createDefaultColors() -> Colors {
        return Colors(
            placeholderIconTintIncoming: UIColor.bma_color(rgb: 0xCED6DC),
            placeholderIconTintOutgoing: UIColor.bma_color(rgb: 0x508DFC),
            progressIndicatorColorIncoming: UIColor.bma_color(rgb: 0x98A3AB),
            progressIndicatorColorOutgoing: UIColor.white,
            overlayColor: UIColor.black.withAlphaComponent(0.70)
        )
    }
}
