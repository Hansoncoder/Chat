//
//  Router.swift
//  BatChat
//
//  Created by Hanson on 2021/5/25.
//

import UIKit
import URLNavigator
import SKPhotoBrowser

struct RouterKeys {
    static let imageKey = "imageKey"
    static let index = "index"
}



class Router {
    static let `default` = Router()
    let navigator = Navigator()
    init() { register() }
    
    
    
    public struct URL {
        /// 传入["imageKey":[UIImage/URL], "index":Int?]
        static let showImage = "app://post/PhotoBlower"
    }
    fileprivate func register() {
        navigator.register(URL.showImage) { (_, _, context) -> UIViewController? in
            guard let context = context as? [AnyHashable: Any],
                  let resource = context[RouterKeys.imageKey] as? [Any] else {
                print("未传入图片，参数名字为\(RouterKeys.imageKey), 值为数组([UIImage]/[String])")
               return nil
            }
            
            var images = [SKPhoto]()
            let index = (context[RouterKeys.index] as? Int) ?? 0
            if let image = resource as? [UIImage], image.count > 0 {
                let photos = image.map { SKPhoto.photoWithImage($0) }
                images.append(contentsOf: photos)
            } else if let image = resource as? [String], image.count > 0 {
                let photos = image.map { SKPhoto.photoWithImageURL($0) }
                images.append(contentsOf: photos)
            }
            
            /// 创建图片预览器，显示图片
            if images.count > 0, index < images.count {
                SKPhotoBrowserOptions.longPhotoWidthMatchScreen = true
                SKPhotoBrowserOptions.enableSingleTapDismiss = true
                SKPhotoBrowserOptions.displayCloseButton = false
                let browser = SKPhotoBrowser(photos: images)
                browser.initializePageIndex(index)
                return browser
            } else {
                print("未传入图片，参数名字为\(RouterKeys.imageKey), 值为数组([UIImage]/[String])")
            }
            return nil
        }
    }

    static func push(_ url: String, context: [AnyHashable: Any]? = nil) {
        `default`.navigator.push(url)
    }

    static func present(_ url: String, context: [AnyHashable: Any]? = nil) {
        `default`.navigator.present(url, context: context)
    }

    static func back(_ animated: Bool = true) {
        UIViewController.topMost?.navigationController?.popViewController(animated: animated)
    }

    static func dismiss() {
        UIViewController.topMost?.dismiss(animated: true, completion: nil)
    }
}
