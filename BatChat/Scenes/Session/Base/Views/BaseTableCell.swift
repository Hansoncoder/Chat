//
//  BaseTableCell.swift
//  BatChat
//
//  Created by Hanson on 2021/5/29.
//

import UIKit

class BaseTableCell: UITableViewCell {
    lazy var containView: UIView = {
        let view = UIView()
        contentView.addSubview(view)
        contentView.backgroundColor = .lineColor
        view.backgroundColor = .white
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lineColor
        contentView.backgroundColor = .white
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class BaseCollectCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lineColor
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

