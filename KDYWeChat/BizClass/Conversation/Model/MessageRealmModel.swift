//
//  MessageRealmModel.swift
//  KDYWeChat
//
//  Created by mac on 16/11/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import RealmSwift

class MessageRealmModel: Object {
    
    /// 用户名
    dynamic var nickname: String = ""
    
    /// 最后一条消息
    dynamic var lastContent: String = ""
    
    /// 头像地址
    dynamic var avatarURLPath: String? = nil
    
    /// 头像数据流
    dynamic var avatarData: NSData? = nil
    
    /// 消息的时间
    dynamic var time: String = ""
    
    // let value: RealmOptional<Int>()
}

