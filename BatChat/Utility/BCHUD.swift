//
//  BCHUD.swift
//  BatChat
//
//  Created by Hanson on 2021/5/25.
//

import PKHUD

public final class BCHUD {

    // MARK: Properties
    public static var dimsBackground: Bool {
        get { return PKHUD.sharedHUD.dimsBackground }
        set { PKHUD.sharedHUD.dimsBackground = newValue }
    }

    public static var allowsInteraction: Bool {
        get { return PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled  }
        set { PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = newValue }
    }

    public static var isVisible: Bool { return PKHUD.sharedHUD.isVisible }

    // MARK: Public methods, PKHUD based
    public static func show(_ content: HUDContentType, onView view: UIView? = nil) {
        dimsBackground = true
        PKHUD.sharedHUD.contentView = contentView(content)
        PKHUD.sharedHUD.show(onView: view)
    }

    public static func hide(_ completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(animated: false, completion: completion)
    }

    public static func hide(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(animated: animated, completion: completion)
    }

    public static func hide(afterDelay delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.hide(afterDelay: delay, completion: completion)
    }

    // MARK: Public methods, HUD based
    public static func flash(_ content: HUDContentType, onView view: UIView? = nil) {
        HUD.show(content, onView: view)
        HUD.hide(animated: true, completion: nil)
    }

    public static func flash(_ content: HUDContentType, onView view: UIView? = nil, delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        HUD.show(content, onView: view)
        HUD.hide(afterDelay: delay, completion: completion)
    }

    // MARK: Private methods
    fileprivate static func contentView(_ content: HUDContentType) -> UIView {
        switch content {
        case .success:
            return PKHUDSuccessView()
        case .error:
            return PKHUDErrorView()
        case .progress:
            return BCHUDProgressView()
        case let .image(image):
            return PKHUDSquareBaseView(image: image)
        case let .rotatingImage(image):
            return PKHUDRotatingImageView(image: image)

        case let .labeledSuccess(title, subtitle):
            return PKHUDSuccessView(title: title, subtitle: subtitle)
        case let .labeledError(title, subtitle):
            return PKHUDErrorView(title: title, subtitle: subtitle)
        case let .labeledProgress(title, subtitle):
            return PKHUDProgressView(title: title, subtitle: subtitle)
        case let .labeledImage(image, title, subtitle):
            return PKHUDSquareBaseView(image: image, title: title, subtitle: subtitle)
        case let .labeledRotatingImage(image, title, subtitle):
            return PKHUDRotatingImageView(image: image, title: title, subtitle: subtitle)

        case let .label(text):
            return PKHUDTextView(text: text)
        case .systemActivity:
            return PKHUDSystemActivityIndicatorView()
        case .customView(let view):
            return view;
        }
    }
}

open class BCHUDProgressView: UIView, PKHUDAnimating {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        super.init(frame: frame)
        backgroundColor = .white
        PKHUD.sharedHUD.dimsBackground = false
        addSubview(imageView)
        addSubview(tipLabel)
        
        tipLabel.text = "正在加载..."
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textColor = "#333333".color
    }

    lazy var tipLabel = UILabel()
    lazy var contentView = UIImageView(image: "loading_top_logo_max".image)
    lazy var imageView: UIImageView = {
        let ringImageView = UIImageView()
        addSubview(contentView)
        addSubview(ringImageView)
        
        ringImageView.image = "loading_top_track_max".image
        return ringImageView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        tipLabel.sizeToFit()
        tipLabel.bottom = height - 14
        tipLabel.centerX = width * 0.5
        
        imageView.size = CGSize(width: 44, height: 44)
        contentView.size = CGSize(width: 26, height: 26)
        imageView.bottom = tipLabel.top - 10
        imageView.centerX = tipLabel.centerX
        contentView.center = imageView.center
    }

    public func startAnimation() {
        backgroundColor = .clear
        imageView.animationRepeatCount = 0
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.duration = 0.5
        anim.repeatCount = MAXFLOAT
        imageView.layer.add(anim, forKey: "rotation-layer")
    }

    public func stopAnimation() {
        imageView.layer.removeAnimation(forKey: "rotation-layer")
    }
}

public func showMessage(_ message: String?, duration: TimeInterval = 1, completion: ((_ didTap: Bool) -> Void)? = nil) {
    BCHUD.hide()
    keyWindow.makeToast(message ?? "网络异常，稍后再试！", duration: duration, completion: completion)
}
