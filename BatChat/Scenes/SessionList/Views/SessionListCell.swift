//
//  SessionListCell.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit
// MARK: - config

extension SessionListCell {
    public func bind(data session: SessionListCellVM) {
        nameLabel.text = session.name
        messageLabel.text = session.message
        iconView.image = session.iconURL?.image
        tipTopView.isHidden = !session.isTop
        tipMessageView.isHidden = session.isDisturb
        tipCountLabel.text = session.unreadCount
        /// 更新提示布局
        tipGroupLabel.isHidden = (session.type != .group)
        updateTipCountLayout(isSystem: session.type == .system)
        
    }
    
    private func updateTipCountLayout(isSystem: Bool) {
        if isSystem {
            iconView.image = "social_chat_notice".image
            tipCountLabel.isHidden = true
            tipCountLabel1.isHidden = false
            tipCountLabel1.text = ""
            tipCountLabel1.layer.cornerRadius = 5
            tipCountLabel1.snp.updateConstraints { make in
                make.width.height.equalTo(10)
            }
        } else {
            iconView.image = .userHead
            tipCountLabel.isHidden = false
            tipCountLabel1.isHidden = (tipCountLabel.text != nil)
            tipCountLabel1.text = "···"
            tipCountLabel1.layer.cornerRadius = 8
            tipCountLabel1.snp.updateConstraints { make in
                make.width.height.equalTo(16)
            }
        }
    }
}

// MARK: SessionListCell
class SessionListCell: BaseTableCell {
    // MARK: - UI
    lazy var iconView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var timeLabel = UILabel()
    lazy var messageLabel = UILabel()
    
    // 用于通知和...
    lazy var tipCountLabel = InsetLabel()
    lazy var tipCountLabel1 = InsetLabel()
    
    lazy var tipGroupLabel = InsetLabel()
    lazy var tipTopView = UIImageView()
    // 免打扰
    lazy var tipMessageView = UIImageView()
    
    private func setupUI() {
        containView.addSubviews([
            iconView, nameLabel, timeLabel,
            messageLabel, tipCountLabel,tipCountLabel1,
            tipTopView, tipGroupLabel,
            tipMessageView
        ])
        
        setupConstraints()
        
        setupAttributed()
    }
    
    private func setupAttributed() {
        iconView.layer.cornerRadius = 4
        nameLabel.setup(.pingfang(17), .blackText)
        messageLabel.setup(.pingfang(14), .grayText)
        timeLabel.setup(.pingfang(12), .grayText)
        
        tipCountLabel.setup(.pingfangMedium(12), .white, .center)
        tipCountLabel.textInsets = UIEdgeInsets(
            top: 0, left: 5, bottom: 0, right: 5
        )
        tipCountLabel.layer.backgroundColor = UIColor.redBack.cgColor
        tipCountLabel.layer.cornerRadius = 8
        
        tipCountLabel1.setup(.boldFont(10), .white, .center)
        tipCountLabel1.layer.backgroundColor = UIColor.redBack.cgColor
        
        tipGroupLabel.setup(.pingfang(10), .orangeText, .center)
        tipGroupLabel.text = "群聊"
        tipGroupLabel.textInsets = UIEdgeInsets(
            top: 0, left: 5, bottom: 0, right: 5
        )
        tipGroupLabel.sizeToFit()
        let radius = tipGroupLabel.height * 0.5
        tipGroupLabel.layer.borderWidth = 1
        tipGroupLabel.corner(
            radius: radius,
            borderWidth: 1,
            borderColor: .orangeText)

        
        tipMessageView.image = "social_icon_list_no".image
        tipTopView.image = "icon_chat_top".image
        
        iconView.image = .userHead
        nameLabel.text = "胖大猫"
        messageLabel.text = "您已添加了半打啤酒为好友，现在可以开始…"
        tipCountLabel.text = "99"
        timeLabel.text = Date().string(format: "HH:mm")
    }
    
    // MARK: - layout
    private func setupConstraints() {
        containView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-0.5)
        }
        
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.left.equalTo(14)
            make.top.equalTo(12)
            make.bottom.equalTo(-13)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(-80)
            make.bottom.equalTo(iconView.snp.centerY).offset(-1)
        }
        messageLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalTo(-21)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        tipCountLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.greaterThanOrEqualTo(16)
            make.centerX.equalTo(iconView.snp.right).offset(-2)
            make.centerY.equalTo(iconView.snp.top).offset(2)
        }
        tipCountLabel1.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerX.equalTo(iconView.snp.right).offset(-2)
            make.centerY.equalTo(iconView.snp.top).offset(2)
        }
        
        tipGroupLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(nameLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView).offset(2)
            make.right.equalTo(-14)
        }
        tipTopView.snp.makeConstraints { make in
            make.width.height.equalTo(9)
            make.top.equalTo(6)
            make.right.equalTo(-6)
        }
        tipMessageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(messageLabel)
            make.right.equalTo(timeLabel)
        }
    }
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

