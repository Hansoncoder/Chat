//
//  ContactListViewController.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

class ContactListViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = BaseViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
