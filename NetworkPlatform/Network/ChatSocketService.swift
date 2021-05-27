//
//  ChatSocketService.swift
//  NetworkPlatform
//
//  Created by Hanson on 2021/5/26.
//

import Domain
import RxSwift
import SocketRocket

class ChatSocketService: SocketService {
    static let shared = ChatSocketService()
    let messageQueue = PublishSubject<ChatSocketService>()
    private var isGroup = false
    private var hasEnter: Bool = false // to be MOVED

    override init() {
        super.init()
        name = "进入聊天"
    }

    // MARK: - 向后台请求socket地址

    public func beginConnet(_ data: ScoreChatGetTokenData, isGroup: Bool) {
        guard let addrData = data.lotteryAddress?.first else { return }
        self.isGroup = isGroup
        if isGroup {
            address = "\(addrData.protocol)://\(addrData.host):\(addrData.port)?groupToken=\(data.token)"
        } else {
            address = "\(addrData.protocol)://\(addrData.host):\(addrData.port)?token=\(data.token)"
        }

        // 开始连接
        start()
    }

    override func onConnect() {
        print(name + "连接成功")
        super.onConnect()
        onResponse(res: ["connet": true])
    }

    override func onDisconnect() {
        super.onConnect()
        print(name + "断开连接")
        onResponse(res: ["connet": true])
    }

    override func stop() {
        super.stop()
        hasEnter = false
    }

    // 获取地址失败、重新发送网络获取
    @objc private func reCreatSocket() {
        guard !isExist() || address == nil else { return }

        let delayTime = 5 // 每隔5s重试
        perform(#selector(super.onResume),
                with: nil,
                afterDelay: TimeInterval(delayTime))
    }
}

// MARK: - 推送数据处理

extension ChatSocketService {
    override func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        guard let msgString = message as? String,
              let json = msgString.toJSON() else {
            return
        }
        var dict = json.toJSONDict()
        if let data = json.dictionary?["data"]?.rawString() {
            dict = data.toJSONDict()
            onResponse(res: dict as NSDictionary)
        }
    }

    func onResponse(res: NSDictionary) {
        /// 发送消息
        messageQueue.onNext(ChatSocketService())
        
        /// 收取消息
        messageQueue.subscribe { aa in
            print(aa.element ?? "ll")
        }.dispose()
    }
}


/// 数据模型
class ScoreChatGetTokenData: ECodable {
    var lotteryAddress: [FMScoreChatGetTokenModel]?
    var token: String = ""
}

/// sock数据模型
class FMScoreChatGetTokenModel: ECodable {
    var host: String = ""
    var port: Int = 0
    var `protocol`: String = ""
}
