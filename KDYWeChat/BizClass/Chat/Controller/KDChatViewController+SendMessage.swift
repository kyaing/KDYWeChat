//
//  KDChatViewController+SendMessage.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/23.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

extension KDChatViewController {
    
    // MARK: - Public Methods
    /**
     *  发送文本消息
     */
    func sendChatTextMessage(_ textView: UITextView) {
        let textMessage =
            EaseSDKHelper.shareInstance.initSendTextMessage(textView.text,
                                                            toUser: self.conversationId,
                                                            messageType: messageTypeFromConversationType(),
                                                            messageExt: nil)
        // 清空输入框
        textView.text = ""
        
        sendMessage(textMessage)
    }
    
    /**
     *  发送图片消息
     */
    func sendChatImageMessage(_ image: UIImage) {
        let imageMessage =
            EaseSDKHelper.shareInstance.initSendImageMessageWithImage(image,
                                                                      toUser: self.conversationId,
                                                                      messageType: messageTypeFromConversationType(),
                                                                      messageExt: nil)
        sendMessage(imageMessage)
    }
    
    /**
     *  发送语音消息
     */
    func sendChatVoiceMessage(_ path: String, duration: Int32) {
        let voiceMessage =
            EaseSDKHelper.shareInstance.initSendVoiceMessageWithLocalPath(path,
                                                                          duration: duration,
                                                                          toUser: self.conversationId,
                                                                          messageType: messageTypeFromConversationType(),
                                                                          messageExt: nil)
        sendMessage(voiceMessage)
    }
    
    /**
     *  发送地理位置消息
     */
    func sendChatLocationMessage(_ latitude: Double, longitude: Double, address: String) {
        let locationMessage =
            EaseSDKHelper.shareInstance.initSendLocationMessageWithLatitude(latitude,
                                                                            longitude: longitude,
                                                                            address: address,
                                                                            toUser: self.conversationId,
                                                                            messageType: messageTypeFromConversationType(),
                                                                            messageExt: nil)
        sendMessage(locationMessage)
    }
    
    /**
     *  发送视频消息
     */
    func sendChatVideoMessage() {
        
    }
    
    /**
     *  将消息添加到数据源中
     */
    func addMessageToDataSource(_ message: EMMessage!) {
        
        // 消息加入到消息数组
        self.messageSource.add(message)
        
        self.messageQueue.async {
            let formatMessages = self.formatEMMessages([message])
            self.itemDataSource.addObjects(from: formatMessages)
            
            self.chatTableView.reloadData()
            
            // 滚动动tableView的底部
            let indexPath = IndexPath(row: self.itemDataSource.count - 1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Private Methods
    fileprivate func sendMessage(_ message: EMMessage!) {
        
        // 添加到数据源中，并发送到服务器上
        addMessageToDataSource(message)
        
        EMClient.shared().chatManager.send(message, progress: { (progress) in
            print("progress = \(progress)")
            
        }) { (message, error) in
            if error == nil {
                self.chatTableView.reloadData()
            } else {
                print("Send Message Error = \(error?.description)")
                self.chatTableView.reloadData()
            }
        }
    }
    
    fileprivate func messageTypeFromConversationType() -> EMChatType {
        var type = EMChatTypeChat
        
        switch (self.conversation.type) {
        case EMConversationTypeChat:
            type = EMChatTypeChat
        case EMConversationTypeGroupChat:
            type = EMChatTypeGroupChat
    
        default:
            break;
        }
        
        return type
    }
}

