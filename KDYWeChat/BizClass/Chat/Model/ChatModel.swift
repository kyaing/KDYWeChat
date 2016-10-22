//
//  ChatModel.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Foundation
import YYText

/* 消息内容类型:
 0 - 文本
 1 - 图片
 2 - 语音
 3 - 群组提示信息，例如:高必梵邀请白琳,彭莹加入群聊
 4 - 文件
 5 - 时间（客户端生成数据）
 */
enum MessageContentType: String {
    case Text   = "0"
    case Image  = "1"
    case Voice  = "2"
    case System = "3"
    case File   = "4"
    case Time   = "5"
}

// 服务器返回的是字符串
enum MessageFromType: String {
    // 消息来源类型
    case System          = "0" // 0是系统
    case Personal        = "1" // 1是个人
    case Group           = "2" // 2是群组
    case PublicServer    = "3" // 服务号
    case PublicSubscribe = "4" // 订阅号
}

/// 聊天数据模型
class ChatModel: NSObject {
    
    var chatSendId : String?        // 发送人 ID
    var chatReceiveId : String?     // 接受人 ID
    var messageContent : String?    // 消息内容
    var messageId : String?         // 消息 ID
    var messageContentType : MessageContentType = .Text //消息内容的类型
    var timestamp : String?         // 同 publishTimestamp
    var messageFromType : MessageFromType = .Group
    var fromMe : Bool = true        // 区分发送者接收者
    
    // 富文本相关(YYLabel)
    var textLayout: YYTextLayout?
    var textLinePositionModifier: TSYYTextLinePositionModifier?
    var textAttributedString: NSMutableAttributedString?
    
    var cellHeight: CGFloat = 0     // 缓存的高度
    
    required override init() {
        
    }
    
    // 自定义时间 TimeModel
    init(timestamp: String) {
        super.init()
        self.timestamp = timestamp
        self.messageContent = "2016-9-27"
        self.messageContentType = .Time
    }
    
    // 自定义发送文本的 ChatModel
    init(text: String) {
        super.init()
        self.timestamp = "2016-9-26"
        self.messageContent = text
        self.messageContentType = .Text
        self.chatSendId = "chatSendId"
    }
}

