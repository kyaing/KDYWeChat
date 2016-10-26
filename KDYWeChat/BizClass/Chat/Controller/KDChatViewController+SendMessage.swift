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
    func sendChatTextMessage(textView: UITextView) {
        let textMessage =
            EaseSDKHelper.shareInstance.initSendTextMessage(textView.text,
                                                            toUser: self.conversationId,
                                                            messageType: messageTypeFromConversationType(),
                                                            messageExt: nil)
        // 清空输入框
        textView.text = ""
        
        self.sendMessage(textMessage)
    }
    
    /**
     *  发送图片消息
     */
    func sendChatImageMessage(image: UIImage) {
        let imageMessage =
            EaseSDKHelper.shareInstance.initSendImageMessageWithImage(image,
                                                                      toUser: self.conversationId,
                                                                      messageType: messageTypeFromConversationType(),
                                                                      messageExt: nil)
        self.sendMessage(imageMessage)
    }
    
    /**
     *  发送语音消息
     */
    func sendChatVoiceMessage() {
        
    }
    
    /**
     *  发送地理位置消息
     */
    func sendChatLocationMessage() {
        
    }
    
    /**
     *  发送视频消息
     */
    func sendChatVoideoMessage() {
        
    }
    
    /**
     *  将发送的消息添加到数据源中
     */
    func addMessageToDataSource(message: EMMessage!) {
        let model = ChatModel(message: message)
        self.itemDataSouce.addObject(model)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.chatTableView.reloadData()
            
            // 滚动动tableView的底部
            let indexPath = NSIndexPath(forRow: self.itemDataSouce.count - 1, inSection: 0)
            self.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func sendMessage(message: EMMessage!) {
        
        // 添加到数据源中，并发送到服务器上
        addMessageToDataSource(message)
        
        EMClient.sharedClient().chatManager.sendMessage(message, progress: { (progress) in
            print("progress = \(progress)")
            
        }) { (message, error) in
            if error != nil {
                self.chatTableView.reloadData()
                
            } else {
                
            }
        }
    }
    
    private func messageTypeFromConversationType() -> EMChatType {
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

