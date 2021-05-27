//
//  UserProfileViewController.swift
//  BatChat
//
//  Created by Hanson on 2021/5/27.
//

import UIKit

class UserProfileViewController: BaseViewController {
    
    lazy var statusView = UIView()
    lazy var bgImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = "mine_bg_view".image
        
        imgView.clipsToBounds = true
        imgView.layer.zPosition = -1
        return imgView
    }()
//    lazy var mineView = FMMineView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        addNavItem()
    }
    
    func addNavItem() {
        
    }

    func setupUI() {
        view.backgroundColor = .backColor
        view.addSubview(bgImageView)
//        view.addSubview(mineView)
        bgImageView.backgroundColor = .white
        
        statusView.alpha = 0
        bgImageView.frame = CGRect(
            x: 0, y: -navBottom,
            width: screenW,
            height: AdaptW(264)
        )
//        mineView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview().inset(UIEdgeInsets(top:
//            navBottom, left: 0, bottom: 0, right: 0))
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = BCSessionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
