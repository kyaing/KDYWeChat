//
//  MessageModel.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

/// 会话数据模型
class MessageModel: NSObject {
    
    /// 会话
    var conversation: EMConversation!
    /// 标题
    var title: String = ""
    /// 头像地址
    var avatarURLPath: String = ""
    /// 头像图片
    var avatarImage: UIImage!
    /// 最新消息内容
    var lastContent: String = ""
    /// 消息时间
    var lastTime: String = ""
    /// 消息未读数
    var unReadCount: String = ""
    
    init(conversation: EMConversation) {
        self.conversation = conversation
        self.title = conversation.conversationId
        
        if conversation.type == EMConversationTypeChat {  // 普通聊天
            self.avatarImage = UIImage(named: "user_avatar")
            
        } else {   // 群组聊天
            self.avatarImage = UIImage(named: "group_avatar")
        }
    }
}

