//
//  TableView+Extension.swift
//  Hanson
//
//  Created by Hanson on 9/7/17.
//  Copyright © 2017 Hanson. All rights reserved.
//

import UIKit

extension UITableView {

    func registerClassOf<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseID)
    }

    func registerNibOf<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseID)
    }

    func registerHeaderFooterClassOf<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseID)
    }

    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseID)")
        }

        return cell
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            fatalError("Could not dequeue HeaderFooter with identifier: \(T.reuseID)")
        }

        return view
    }
    
    
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}
