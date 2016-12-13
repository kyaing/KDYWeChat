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

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/* 消息内容类型:
 0 - 文本
 1 - 时间
 2 - 图片
 3 - 语音
 4 - 视频
 5 - 位置
 6 - 系统提示
 */
enum MessageContentType: String {
    case Text     = "0"
    case Time     = "1"
    case Image    = "2"
    case Voice    = "3"
    case Video    = "4"
    case Location = "5"
    case System   = "6"
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
    
    var message: EMMessage!
    var messageType: EMChatType!
    var bodyType: EMMessageBodyType!
    var firstMessageBody: EMMessageBody!
    
    /// 消息发送的状态
    var messageStatus: EMMessageStatus {
        return self.message.status
    }

    var messageContent : String!    // 消息内容
    
    var messageId : String {        // 消息 ID
        return self.message.messageId
    }
    
    var nickname: String?           // 昵称
    var avatarURL: String?          // 头像地址
    var messageContentType: MessageContentType = .Text //消息内容的类型
    
    var image: UIImage?             // 图片
    var thumbnailImage: UIImage?    // 图片的缩略图
    
    var imageSize: CGSize!          // 图片尺寸
    var thumbnailImageSize: CGSize! // 缩略图尺寸
    
    var fileURLPath: String?        // 文件地址
    
    var localFilePath: String?      // 本地文件路径
    
    var duration: Float!            // 语音时长
    
    var timestamp : String?         // 同 publishTimestamp
    var messageFromType : MessageFromType = .Group
    
    var fromMe : Bool!              // 区分发送者接收者
    
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
        self.messageContentType = .Time
    }
    
    init(message: EMMessage) {
        super.init()
        
        self.message          = message
        self.messageType      = message.chatType
        self.firstMessageBody = message.body

        self.nickname         = message.from
        self.fromMe           = (message.direction == EMMessageDirectionSend) ? true : false
        
        switch self.firstMessageBody.type {
        case EMMessageBodyTypeText:
            self.messageContentType = .Text
            
            let textBody = firstMessageBody as! EMTextMessageBody
            self.messageContent = textBody.text
            
        case EMMessageBodyTypeImage:
            self.messageContentType = .Image
            
            let imageBody = firstMessageBody as! EMImageMessageBody
            let imageData = try? Data(contentsOf: URL(fileURLWithPath: imageBody.localPath))
            
            if imageData?.count > 0 {
                self.image = UIImage(data: imageData!)
            }
            
            if imageBody.thumbnailLocalPath.characters.count > 0 { 
                self.thumbnailImage = UIImage(contentsOfFile: imageBody.thumbnailLocalPath)
                
            } else {
                let size = self.image!.size
                self.thumbnailImage = size.width * size.height >= 120 * 120 ? UIImage.scaleImage(self.image!, scaleSize: 0.5) : self.image
            }
            
            self.imageSize = imageBody.size
            self.thumbnailImageSize = self.thumbnailImage?.size
            
            if !fromMe {
                self.fileURLPath = imageBody.remotePath
            }
            self.localFilePath = imageBody.localPath
        
        case EMMessageBodyTypeVoice:
            self.messageContentType = .Voice
            
            let voiceBody = firstMessageBody as! EMVoiceMessageBody
            self.duration = Float32(voiceBody.duration)
            
            self.fileURLPath = voiceBody.remotePath
            self.localFilePath = voiceBody.localPath
            
        default:
            break
        }
    }
}

