//
//  NibLoadable.swift
//  forum
//
//  Created by Hanson on 2020/1/11.
//  Copyright © 2020 Hanson. All rights reserved.
//

import UIKit

// 加载nib
protocol NibLoadable {
    static var nibName: String { get }
}

extension NibLoadable {
    static var nibName: String {
        return String(describing: self)
    }
}


// 这三个是UIView的子类
//extension UITableViewCell: NibLoadable {}
//extension UITableViewHeaderFooterView: NibLoadable {}
//extension UICollectionReusableView: NibLoadable {}

extension UIView: NibLoadable { }

extension UIViewController: NibLoadable { }

extension NibLoadable {
    static func loadFromNib() -> Self {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! Self
    }
}
