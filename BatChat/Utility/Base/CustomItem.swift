//
//  CustomItem.swift
//  forum
//
//  Created by Hanson on 2020/1/17.
//  Copyright © 2020 Hanson. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class CustomItem: UIBarButtonItem {

    let button = UIButton(type: .custom)
    
    typealias ItemClick = () -> Void ///< 定义确认回调
    var selectedBack: ItemClick?
    var imageName: String?
    override var title: String?{
        didSet {
            button.setTitle(title, for: .normal)
            button.sizeToFit()
            button.width += 10
        }
    }
    
    override var tintColor: UIColor? {
        didSet {
            button.setTitleColor(tintColor, for: .normal)
        }
    }
    
    // MARK: - setup
    convenience init(_ imageName: String?) {
        self.init()
        self.imageName = imageName
        if let name = imageName {
            button.setImage(name.image, for: .normal)
            return
        }
        button.setTitle("   ", for: .normal)
    }
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
}

extension CustomItem {
    private func setup() {
        self.customView = button
        button.titleLabel?.font = .systemFont(ofSize: 15)
        let edgeInsets = UIEdgeInsets(top: 0, left: 10,
                                      bottom: 0, right: 0)
        button.titleEdgeInsets = edgeInsets
        button.setTitleColor(.themeBack, for: .normal)
        button.sizeToFit()
        button.width += 10
        
        button.addTarget(self, action: #selector(dateClick), for: .touchUpInside)
    }
    
    @objc func dateClick() {
        selectedBack?()
    }
    
    
}

extension Reactive where Base: CustomItem {
    // 扩展点击事件
//    var tapCustom: ControlEvent<Void> {
//        let source: Observable<Void> = Observable.create {
//            [weak control = self.base] observer  in
//            guard let control = control else {
//                observer.on(.completed)
//                return Disposables.create()
//            }
//            control.selectedBack = {
//                observer.on(.next(()))
//            }
//            return Disposables.create()
//        }
//        return ControlEvent(events: source)
//    }
}
