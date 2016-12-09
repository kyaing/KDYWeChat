//
//  MessageDBModel.swift
//  KDYWeChat
//
//  Created by mac on 16/11/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import RealmSwift

class MessageDBModel: Object {
    
    /// 用户名
    var nickname: String = ""
    
    /// 最后一条消息
    var lastContent: String = ""
    
    /// 头像地址
    var avatarURLPath: String = ""
    
    /// 头像数据流
    var avatarData: Data? = nil
    
    /// 消息的时间
    var time: String = ""
}

