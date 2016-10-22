//
//  MessageModel.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

/// 会话数据模型
class MessageModel: NSObject {
    var conversation: EMConversation!
    
    var title: String = ""
    var avatarURLPath: String = ""
    var avatarImage: UIImage!
    
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

