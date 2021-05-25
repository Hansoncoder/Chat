//
//  BCMainViewController.swift
//  BatChat
//
//  Created by Hanson on 2021/2/3.
//

import UIKit
import Domain
import NetworkPlatform

public enum TabbarType {
    case girl
    case boy
    case chat
    case profile
}

// FIXME: 控制子控制器
func vcs() -> [TabbarType] {
    return [.girl, .boy, .chat , .profile]
}

// AMRK: - 主体
class DSMainViewController: UITabBarController {
    private let dataProvider = NetworkPlatform.UseCaseProvider()
    var childs: [TabbarType]
    init(_ childs: [TabbarType] = vcs()) {
        self.childs = childs
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        commonInit()
        
        childs.forEach {
            let vc = makeChild(setupVC($0))
            addChild(vc)
        }
        /// tabar背景图片和线条颜色
        tabBar.backgroundImage = UIColor.white.image
        tabBar.shadowImage = "E6E6E6".color.image
    }

    

    private func makeChild(_ model: TabbarModel) -> NavigationController {
        let vc = NavigationController()
        let navigator = model.navType.init(navigator: vc)
        vc.tabBarItem = UITabBarItem(
            title: model.title,
            image: model.icon.normalImage,
            selectedImage: model.icon.selectImage
        )

        navigator.showDefault()
        
        return vc
    }

    
    //MARK: - 设置底部tabbar的主题样式
    func commonInit() {
        
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.themeBack], for: UIControl.State.selected)
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: "#969BA3".color], for: .normal)
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        if #available(iOS 13.0, *) {
            UITabBar.appearance().unselectedItemTintColor = "969BA3".color
            UITabBar.appearance().tintColor = .themeBack
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 自控制器变动
fileprivate struct TabbarModel {
    let navType: BCNavigator.Type
    let title: String
    let icon: String
}

extension DSMainViewController {

    private func setupVC(_ type: TabbarType) -> TabbarModel {
        switch type {
        case .girl:
            return TabbarModel(
                navType: BCDefaultHomeNavigator.self,
                title: "聊天", icon: "tab_girl")
        case .boy:
            return TabbarModel(
                navType: BCDefaultHomeNavigator.self,
                title: "通讯录", icon: "tab_boy")
        case .chat:
            return TabbarModel(
                navType: BCDefaultHomeNavigator.self,
                title: "兴趣", icon: "tab_message")
        case .profile:
            return TabbarModel(
                navType: BCDefaultHomeNavigator.self,
                title: "我的", icon: "tab_mine")
        }
    }
}
