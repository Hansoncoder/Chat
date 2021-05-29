//
//  TableViewFactory.swift
//  Hanson
//
//  Created by Hanson on 9/13/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit

class TableViewFactory {
    
    class func create(_ style: UITableView.Style = .plain, hasHeader: Bool = true) -> UITableView {
        let view = UITableView(frame: CGRect.zero, style: style)
        setupView(view)
        guard style == .grouped, hasHeader else {
            return view
        }
        
        // 去掉 .grouped样式 顶部和底部空白
        let inset = UIEdgeInsets(top: -35, left: 0, bottom: -20, right: 0)
        view.contentInset = inset
        return view
    }
    
    class func setupView(_ view: UITableView) {
        view.backgroundColor = .backColor
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedSectionHeaderHeight = UITableView.automaticDimension
        view.estimatedSectionFooterHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            // 解决 tableView 执行 reload 抖动问题
            view.estimatedRowHeight = screenH
            view.contentInsetAdjustmentBehavior = .never
        }
    }
}
