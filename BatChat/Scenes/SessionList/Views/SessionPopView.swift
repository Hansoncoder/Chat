//
//  SessionPopView.swift
//  BatChat
//
//  Created by Hanson on 2021/5/29.
//

import UIKit

public enum ShowCorner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

extension SessionPopView {
    public static func sessionCreatList() -> [ChooseModel] {
        let m1 = ChooseModel(
            imageName: "icon_chat_window_contacts",
            title: "添加联系人")
        let m2 = ChooseModel(
            imageName: "icon_chat_window_group",
            title: "创建群组")
        let m3 = ChooseModel(
            imageName: "icon_chat_window_scan",
            title: "扫一扫")
        return [m1, m2, m3]
    }
}

extension SessionPopView {
    static public func hidden() {
        share.hidden()
    }
    
    
    /// 显示在哪个视图附近
    /// - Parameters:
    ///   - target:目标视图
    ///   - dataSource: 数据源
    ///   - corner: 显示位置
    ///   - tx: 水平偏移
    ///   - ty: 垂直偏移
    ///   - clickedAction: 点击事件
    public static func show(_ target: UIView, dataSource: [ChooseModel], corner:ShowCorner, tx: CGFloat = 0, ty: CGFloat = 0, clickedAction: @escaping ((_ index: Int) -> Void)) {
        share.dataSource = dataSource
        share.didClick = clickedAction
        
        var rect = target.convert(target.bounds, to: keyWindow)
        rect.x += tx
        rect.y += ty
        share.arrowImage.x = -tx
        share.arrowImage.y = -ty
        share.show(targeRect: rect, corner: corner)
    }
    
    @objc private func hidden() {
        UIView.animate(withDuration: 0.6, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    private func show(targeRect: CGRect, corner:ShowCorner) {
        guard dataSource.count > 0 else {
            return
        }
        
        let tempSize = CGSize(width: 180, height: CGFloat(dataSource.count) * rowHeight + arrowHeight)
        var x: CGFloat = 0
        var y: CGFloat = 0
        switch corner {
        case .topLeft:
            x = (targeRect.maxX - tempSize.width)
            y = targeRect.y - tempSize.height
            
            arrowImage.centerX = targeRect.midX - x + arrowImage.x
            arrowImage.bottom = tempSize.height
        case .topRight:
            x = targeRect.x
            y = targeRect.y - tempSize.height
            
            arrowImage.centerX = targeRect.midX - x + arrowImage.x
            arrowImage.bottom = tempSize.height

        case .bottomLeft:
            x = (targeRect.maxX - tempSize.width)
            y = targeRect.maxY
            
            arrowImage.centerX = targeRect.midX - x + arrowImage.x
            arrowImage.top = 0

        case .bottomRight:
            x = targeRect.x
            y = targeRect.maxY
            
            arrowImage.centerX = targeRect.midX - x + arrowImage.x
            arrowImage.top = 0
        }
        
        contentView.frame = CGRect(origin: CGPoint(x: x, y: y), size: tempSize)
        tableView.frame = CGRect(
            x: 0, y: arrowHeight,
            width: tempSize.width,
            height: tempSize.height - arrowHeight)
        
        self.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        keyWindow.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
}

class SessionPopView: UIView {
    // MARK: - UI
    public var rowHeight: CGFloat = 50
    public var arrowHeight: CGFloat = 7
    var didClick: ((_ index: Int) -> Void)? = nil
    
    static private let share = SessionPopView()
    lazy var contentView = UIView()
    lazy var dataSource: [ChooseModel] = []
    lazy var tableView = TableViewFactory.create()
    lazy var backButton = UIButton(type: .custom)
    lazy var arrowImage = UIImageView()
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        tableView.backgroundColor = .white
        
        addSubview(backButton)
        backButton.backgroundColor = UIColor(white: 0, alpha: 0.01)
        backButton.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        
        addSubview(contentView)
        
        contentView.addSubview(tableView)
        contentView.addSubview(arrowImage)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        
        setupAttributes()
        
        setupConstraints()
    }
    
    private func setupAttributes() {
        tableView.layer.cornerRadius = 2
        tableView.layer.masksToBounds = true
        
        contentView.layer.shadowColor = "BFBFBF".color.cgColor
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = CGSize(width: 0, height: -1)
        
        arrowImage.image = "icon_nav_triangle".image
        arrowImage.size = CGSize(width: 18, height: 8)
        
    }
    
    // MARK: - layout
    private func setupConstraints() {
        backButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

extension SessionPopView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CoverViewCell()
        cell.titleLabel.text = dataSource[indexPath.row].title
        cell.imageView?.image = dataSource[indexPath.row].imageName?.image
        return cell
    }
    
}

extension SessionPopView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didClick?(indexPath.row)
        removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

class CoverViewCell: BaseTableCell {
    // MARK: - UI
    lazy var iconView = UIImageView()
    lazy var titleLabel = UILabel()
    
    private func setupUI() {
        containView.addSubview(iconView)
        containView.addSubview(titleLabel)
        
        setupAttributed()
        
        setupConstraints()
    }
    
    private func setupAttributed() {
        contentView.backgroundColor = .backColor
        containView.backgroundColor = .white
        
        titleLabel.font = .pingfang(17)
        titleLabel.textColor = .blackText
        titleLabel.textAlignment = .left
    }
    
    // MARK: - layout
    private func setupConstraints() {
        iconView.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(16)
            make.top.bottom.right.equalToSuperview()
        }
        
        containView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
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

struct ChooseModel {
    let imageName: String?
    let title: String?
}
