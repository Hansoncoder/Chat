import UIKit
import Domain
import NetworkPlatform


let netwokData = NetworkPlatform.UseCaseProvider()
final class Application {
    static let shared = Application()

    func configureMainInterface(in window: UIWindow) {
        let vc = NavigationController()
        let navigator = DefaulAccountNavigator(navigator: vc)
    
        window.rootViewController = vc
        navigator.showDefault()
    }
    
    func showTabbar() {
        let tabBarController = DSMainViewController()
        keyWindow.rootViewController = tabBarController
    }
    
}
    
