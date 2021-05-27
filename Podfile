# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
inhibit_all_warnings!

def rx_swift
    pod 'RxSwift', '~> 5.0'
end

def rx_cocoa
    pod 'RxCocoa', '~> 5.0'
end

def target_pods
  pod 'MJRefresh'
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'EFNavigationBar', '5.2.3'
  pod 'RxDataSources'
  pod 'URLNavigator',     '2.2.0' #Router跳转
  pod 'SKPhotoBrowser' # 图片预览器
  pod 'PKHUD'
  pod 'Chatto', '= 4.0.0'
  
  ## 字符处理
  pod 'Dollar'
  pod 'KeychainAccess'
  
end

def test_pods
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'Nimble'
end

target 'BatChat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  rx_cocoa
  rx_swift
  target_pods

end

target 'Domain' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  rx_swift

end

target 'NetworkPlatform' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    rx_swift
    pod 'SocketRocket'
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'Hyphenate'
    pod "Codextended"
    pod 'SwiftyJSON'
    
end
