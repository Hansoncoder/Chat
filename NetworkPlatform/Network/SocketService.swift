//
//  SocketService.swift
//  NetworkPlatform
//
//  Created by Hanson on 2021/5/26.
//

import UIKit
import SwiftyJSON
import RxAlamofire
import Alamofire
import SocketRocket

class SocketService: NSObject {
    var address:String!
    var name:String!
    private var socket: SRWebSocket!
    private var socketHeartTimer:Timer!
    private var reConnectCount = 0
    private var reachabilityManager = NetworkReachabilityManager()

    // MARK: - 初始化
    
    override init() {
        super.init()
        
        // 网络监控
        addReachability()
        
        // 添加监听
        addNotify()
    }
    
    /// 初始化 && onResume 连接
    @objc func start() {
        if self.address == nil {
            print("please set socket address")
            return
        }
        if self.socket != nil {
            self.stop()
        }
        self.socket = SRWebSocket(url: URL(string: self.address)!)
    
        // 连接
        self.onResume()
    }
    
    // MARK: - private
    
    /// 连接成功
    @objc func onConnect() {
        print(self.name+"--启动成功")
        self.reConnectCount = 0
        self.startHeartTimer()
    }
    
    /// 连接断开
    @objc func onDisconnect() {
        if reConnectCount >= 1 {// 断网时会走2次onDisconnect
            self.onMutableDisconnectFail()
            return
        }
        reConnet()
    }
    
    /// 心跳开启
    private func startHeartTimer(){
        self.socketHeartTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(sendPing), userInfo: nil, repeats: true)
        RunLoop.current.add(self.socketHeartTimer, forMode: .common)
    }
    
    /// 心跳结束
    private func stopHeartTimer(){
        if self.socketHeartTimer != nil {
            self.socketHeartTimer.invalidate()
            self.socketHeartTimer = nil
        }
    }
    
    /// 心跳action
    @objc private func sendPing(){
        /// webscoket 心跳检测 每隔1分钟send一个0 server会返回一个1
        let message = "0"
        self.sendMessage(message: message)
    }
    
    
    // MARK: - public
    
    /// 销毁socket
    func stop() {
        print(self.name+"--socket stop")
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if self.socket != nil {
            self.socket.close()
            self.socket.delegate = nil
            self.socket = nil
        }
    }
    
    /// 进入后台断开连接
    @objc func onPause() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.reConnectCount = 0
        if self.isActive() {
            print(self.name+"--onPause")
            socket.close()
            socket.delegate = nil
            socket = nil
        }
    }
    
    /// 连接
    @objc func onResume() {
        // 处于链接状态
        if isActive() {
            onConnect()
            return
        }
        
        guard socket != nil, isRedy() else {
            start()
            return
        }
        
        // 加锁
        objc_sync_enter(self.socket!)
        socket.delegate = self
        socket.open()
        objc_sync_exit(self.socket!)
    }
    
    /// 发送消息
    func sendMessage(message: String) {
        guard isActive() else { return }
        
        socket.send(message)
    }
    
    /// socket 是否存在
    func isExist() -> Bool {
        return self.socket != nil
    }
    
    /// socket 是否已连接
    func isActive() -> Bool {
        if self.socket != nil {
            return (socket.readyState == .OPEN)
        }
        return false
    }
    
    func isRedy() -> Bool {
        if self.socket != nil {
            return (socket.readyState == .CONNECTING)
        }
        return false
    }
    
    // MARK: - for subclass
    func onMutableDisconnectFail() {
        print(self.name+"--多次重连失败，请检查您的网络状况")
        self.reConnectCount = 0
    }
    
}

// MARK: - 重连机制
extension SocketService {
    
    private func addNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(reConnet), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func addReachability() {
        // 切换网络自动重连
        reachabilityManager?.startListening { [weak self] (networkReachabilityStatus) in
            // 正在连接中或已经连接成功，不需要重连
            if let active = self?.isActive(), active {
                return
            }
            
            guard let `self` = self else { return }
            
            // 断网自动重连
            self.reConnet()
            
        }
    }
    
    @objc private func reConnet() {
        self.reConnectCount = self.reConnectCount + 1
        let delayTime = pow(2.0, Double(self.reConnectCount))
        print(self.name + "--当前重连次数：\(self.reConnectCount)，\(delayTime)S后进行下一次重连")
        self.perform(#selector(self.onResume), with: nil, afterDelay: TimeInterval(delayTime))
    }
}

// MARK: - SRWebSocketDelegate
extension SocketService: SRWebSocketDelegate {
    
    // 连接成功，开启心跳
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        onConnect()
    }
    // 心跳回应
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
//        let jsonData = try? JSON(data: pongPayload)
    }
    // 连接被关闭
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        onPause()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        onDisconnect()
    }
    
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
    }
}

