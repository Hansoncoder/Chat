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

import Chatto
import UIKit

public protocol TextBubbleViewStyleProtocol {
    func bubbleImage(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImageBorder(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIImage?
    func textFont(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func textColor(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIColor
    func textInsets(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIEdgeInsets
}

public final class TextBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {
    public var preferredMaxLayoutWidth: CGFloat = 0
    public var animationDuration: CFTimeInterval = 0.33
    public var viewContext: ViewContext = .normal {
        didSet {
            if viewContext == .sizing {
                textView.dataDetectorTypes = UIDataDetectorTypes()
                textView.isSelectable = false
            } else {
                textView.dataDetectorTypes = .all
                textView.isSelectable = true
            }
        }
    }

    public var style: TextBubbleViewStyleProtocol! {
        didSet {
            updateViews()
        }
    }

    public var textMessageViewModel: TextMessageViewModelProtocol! {
        didSet {
            accessibilityIdentifier = textMessageViewModel.bubbleAccessibilityIdentifier
            updateViews()
        }
    }

    public var selected: Bool = false {
        didSet {
            if self.selected != oldValue {
                self.updateViews()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(bubbleImageView)
        addSubview(textView)
    }

    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        self.borderImageView.contentMode = .scaleToFill
        imageView.accessibilityIdentifier = "chatto.message.text.image.bubble"
        return imageView
    }()

    private var borderImageView: UIImageView = UIImageView()
    private var textView: UITextView = {
        let textView = ChatMessageTextView()
        UIView.performWithoutAnimation({ () -> Void in // fixes iOS 8 blinking when cell appears
            textView.backgroundColor = UIColor.clear
        })
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = .all
        textView.scrollsToTop = false
        textView.isScrollEnabled = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isExclusiveTouch = true
        textView.textContainer.lineFragmentPadding = 0
        textView.disableDragInteraction()
        textView.disableLargeContentViewer()
        return textView
    }()

    public private(set) var isUpdating: Bool = false
    public func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() -> Void)?) {
        isUpdating = true
        let updateAndRefreshViews = {
            updateClosure()
            self.isUpdating = false
            self.updateViews()
            if animated {
                self.layoutIfNeeded()
            }
        }
        if animated {
            UIView.animate(withDuration: animationDuration, animations: updateAndRefreshViews, completion: { (_) -> Void in
                completion?()
            })
        } else {
            updateAndRefreshViews()
        }
    }

    private func updateViews() {
        if viewContext == .sizing { return }
        if isUpdating { return }
        guard let style = self.style else { return }

        updateTextView()
        let bubbleImage = style.bubbleImage(viewModel: textMessageViewModel, isSelected: selected)
        let borderImage = style.bubbleImageBorder(viewModel: textMessageViewModel, isSelected: selected)
        if bubbleImageView.image != bubbleImage { bubbleImageView.image = bubbleImage.bubbleResizable }
        if borderImageView.image != borderImage { borderImageView.image = borderImage?.bubbleResizable }
    }

    private func updateTextView() {
        guard let style = self.style, let viewModel = textMessageViewModel else { return }

        let font = style.textFont(viewModel: viewModel, isSelected: selected)
        let textColor = style.textColor(viewModel: viewModel, isSelected: selected)

        var needsToUpdateText = false

        if textView.font != font {
            textView.font = font
            needsToUpdateText = true
        }

        if textView.textColor != textColor {
            textView.textColor = textColor
            textView.linkTextAttributes = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            ]
            needsToUpdateText = true
        }

        if needsToUpdateText || textView.text != viewModel.text {
            let attText = viewModel.text.textToEmoji()
            let textFont = self.style.textFont(viewModel: textMessageViewModel, isSelected: selected)
            attText.addAttributes([.font: textFont], range: attText.string.allRange())

            viewModel.AttText = attText
            textView.attributedText = attText
            textMessageViewModel.AttText = attText
        }

        let textInsets = style.textInsets(viewModel: viewModel, isSelected: selected)
        if textView.textContainerInset != textInsets { textView.textContainerInset = textInsets }
    }

    private func bubbleImage() -> UIImage {
        return style.bubbleImage(viewModel: textMessageViewModel, isSelected: selected)
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return calculateTextBubbleLayout(preferredMaxLayoutWidth: size.width).size
    }

    // MARK: Layout

    override public func layoutSubviews() {
        super.layoutSubviews()
        let layout = calculateTextBubbleLayout(preferredMaxLayoutWidth: preferredMaxLayoutWidth)
        textView.bma_rect = layout.textFrame
        bubbleImageView.bma_rect = layout.bubbleFrame
        borderImageView.frame = bubbleImageView.bounds
    }

    public var layoutCache: NSCache<AnyObject, AnyObject>!
    private func calculateTextBubbleLayout(preferredMaxLayoutWidth: CGFloat) -> TextBubbleLayoutModel {
        let layoutContext = TextBubbleLayoutModel.LayoutContext(
            text: textMessageViewModel.text,
            attText: textMessageViewModel.AttText,
            font: style.textFont(viewModel: textMessageViewModel, isSelected: selected),
            textInsets: style.textInsets(viewModel: textMessageViewModel, isSelected: selected),
            preferredMaxLayoutWidth: preferredMaxLayoutWidth
        )

        if let layoutModel = layoutCache.object(forKey: layoutContext.hashValue as AnyObject) as? TextBubbleLayoutModel, layoutModel.layoutContext == layoutContext {
            return layoutModel
        }

        let layoutModel = TextBubbleLayoutModel(layoutContext: layoutContext)
        layoutModel.calculateLayout()

        layoutCache.setObject(layoutModel, forKey: layoutContext.hashValue as AnyObject)
        return layoutModel
    }

    public var canCalculateSizeInBackground: Bool {
        return true
    }
}

private final class TextBubbleLayoutModel {
    let layoutContext: LayoutContext
    var textFrame: CGRect = CGRect.zero
    var bubbleFrame: CGRect = CGRect.zero
    var size: CGSize = CGSize.zero

    init(layoutContext: LayoutContext) {
        self.layoutContext = layoutContext
    }

    struct LayoutContext: Equatable, Hashable {
        let text: String
        let attText: NSAttributedString?
        let font: UIFont
        let textInsets: UIEdgeInsets
        let preferredMaxLayoutWidth: CGFloat
    }

    func calculateLayout() {
        let textHorizontalInset = layoutContext.textInsets.bma_horziontalInset
        let maxTextWidth = layoutContext.preferredMaxLayoutWidth - textHorizontalInset
        let textSize = textSizeThatFitsWidth(maxTextWidth)
        let bubbleSize = textSize.bma_outsetBy(dx: textHorizontalInset, dy: layoutContext.textInsets.bma_verticalInset)
        bubbleFrame = CGRect(origin: CGPoint.zero, size: bubbleSize)
        textFrame = bubbleFrame
        size = bubbleSize
    }

    private func textSizeThatFitsWidth(_ width: CGFloat) -> CGSize {
        let textContainer: NSTextContainer = {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let container = NSTextContainer(size: size)
            container.lineFragmentPadding = 0
            return container
        }()

        let textStorage = replicateUITextViewNSTextStorage()
        let layoutManager: NSLayoutManager = {
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            return layoutManager
        }()

        let rect = layoutManager.usedRect(for: textContainer)
        return rect.size.bma_round()
    }

    private func replicateUITextViewNSTextStorage() -> NSTextStorage {
        // See https://github.com/badoo/Chatto/issues/129
        if let attText = layoutContext.attText {
            return NSTextStorage(attributedString: attText)
        }

        let attText = layoutContext.text.textToEmoji()
        attText.addAttributes([.font: layoutContext.font], range: attText.string.allRange())
        return NSTextStorage(attributedString: attText)
    }
}

/// UITextView with hacks to avoid selection, loupe, define...
private final class ChatMessageTextView: UITextView {
    override var canBecomeFirstResponder: Bool {
        return false
    }

    // See https://github.com/badoo/Chatto/issues/363
    override var gestureRecognizers: [UIGestureRecognizer]? {
        set {
            super.gestureRecognizers = newValue
        }
        get {
            return super.gestureRecognizers?.filter { gestureRecognizer in
                if #available(iOS 13, *) {
                    return !ChatMessageTextView.notAllowedGestureRecognizerNames.contains(gestureRecognizer.name?.base64String ?? "")
                }
                if #available(iOS 11, *), gestureRecognizer.name?.base64String == SystemGestureRecognizerNames.linkTap.rawValue {
                    return true
                }
                if type(of: gestureRecognizer) == UILongPressGestureRecognizer.self, gestureRecognizer.delaysTouchesEnded {
                    return true
                }
                return false
            }
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override var selectedRange: NSRange {
        get {
            return NSRange(location: 0, length: 0)
        }
        set {
            // Part of the heaviest stack trace when scrolling (when updating text)
            // See https://github.com/badoo/Chatto/pull/144
        }
    }

    override var contentOffset: CGPoint {
        get {
            return .zero
        }
        set {
            // Part of the heaviest stack trace when scrolling (when bounds are set)
            // See https://github.com/badoo/Chatto/pull/144
        }
    }

    fileprivate func disableDragInteraction() {
        if #available(iOS 11.0, *) {
            self.textDragInteraction?.isEnabled = false
        }
    }

    fileprivate func disableLargeContentViewer() {
        #if compiler(>=5.1)
            if #available(iOS 13.0, *) {
                self.showsLargeContentViewer = false
            }
        #endif
    }

    private static let notAllowedGestureRecognizerNames: Set<String> = Set([
        SystemGestureRecognizerNames.forcePress.rawValue,
        SystemGestureRecognizerNames.loupe.rawValue,
    ])
}

private enum SystemGestureRecognizerNames: String {
    // _UIKeyboardTextSelectionGestureForcePress
    case forcePress = "X1VJS2V5Ym9hcmRUZXh0U2VsZWN0aW9uR2VzdHVyZUZvcmNlUHJlc3M="
    // UITextInteractionNameLoupe
    case loupe = "VUlUZXh0SW50ZXJhY3Rpb25OYW1lTG91cGU="
    // UITextInteractionNameLinkTap
    case linkTap = "VUlUZXh0SW50ZXJhY3Rpb25OYW1lTGlua1RhcA=="
}

private extension String {
    var base64String: String? {
        return data(using: .utf8)?.base64EncodedString()
    }
}

extension UIImage {
    
    /// 图片边框保护 拉伸模式
    var bubbleResizable: UIImage {
        let widht = (size.width * 0.5)
        let inset = UIEdgeInsets(
            top: size.height * 0.6, left: widht,
            bottom: size.height * 0.3, right: widht)
        return resizableImage(withCapInsets: inset)
    }
}
