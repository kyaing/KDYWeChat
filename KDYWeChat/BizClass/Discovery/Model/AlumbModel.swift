//
//  AlumbModel.swift
//  KDYWeChat
//
//  Created by mac on 16/11/11.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 朋友圈模型
class AlumbModel: NSObject {
    
    /// 头像地址
    var avatarURL: String!
    /// 用户昵称
    var nickname: String!
    /// 发布时间
    var time: String!
    /// 文本内容
    var contentText: String?
    
    required override init() {
        
    }
    
    init(url: String, nickname: String, time: String, text: String) {
        super.init()
        
        self.avatarURL   = url
        self.nickname    = nickname
        self.time        = time
        self.contentText = text
    }
}

