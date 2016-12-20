//
//  KDYChatHelper.swift
//  KDYWeChat
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

class KDYChatHelper: NSObject {
    
    // MARK: - Parameters
    var mainTabbarVC: KDTabBarController?
    var conversationVC: KDConversationViewController?
    var contactVC: KDContactsViewController?
    var chatVC: KDChatViewController?
    
    // MARK: - Life Cycle
    static let share = KDYChatHelper()
    fileprivate override init() {
        super.init()
        self.initHeapler()
    }
    
    func initHeapler() {
        EMClient.shared().add(self, delegateQueue: nil)
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        EMClient.shared().contactManager.add(self, delegateQueue: nil)
        EMClient.shared().groupManager.add(self, delegateQueue: nil)
    }
    
    deinit {
        EMClient.shared().removeDelegate(self)
        EMClient.shared().chatManager.remove(self)
        EMClient.shared().contactManager.removeDelegate(self)
        EMClient.shared().groupManager.removeDelegate(self)
    }
    
    func clearHeapler() {
        self.mainTabbarVC = nil
    }
    
    // MARK: - Public Methods
    func asyncPushOptions() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            var error: EMError?
            EMClient.shared().getPushOptionsFromServerWithError(&error)
        }
    }
    
    func asyncConversationFromDB() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let conversations: NSArray = EMClient.shared().chatManager.getAllConversations() as NSArray
            conversations.enumerateObjects({ (conversation, idx, stop) in
                
                let conversation = conversation as! EMConversation
                if conversation.latestMessage == nil {
                    // 当会话最后一条信息为空，则删除此会话
                    EMClient.shared().chatManager.deleteConversation(conversation.conversationId,
                        isDeleteMessages: false, completion: nil)
                }
            })
        }
        
        DispatchQueue.main.async {
            // 设置未读消息数
            if (self.mainTabbarVC != nil) {
                self.mainTabbarVC!.setupUnReadMessageCount()
            }
            
            // 刷新会话数据
            if (self.conversationVC != nil) {
                self.conversationVC!.refreshConversations()
            }
        }
    }
}

// MARK: - EMClientDelegate
extension KDYChatHelper: EMClientDelegate {
    /**
     *  监测sdk的网络状态
     */
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        if (self.mainTabbarVC != nil) {
            self.mainTabbarVC!.networkStateChanged(aConnectionState)
        }
    }
    
    /**
     *  自动登录失败时的回调
     */
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        
    }
    
    /**
     *  账号被从服务器删除
     */
    func userAccountDidRemoveFromServer() {
        
    }
    
    /**
     *  账号在其它设备登录
     */
    func userAccountDidLoginFromOtherDevice() {
        
    }
}

// MARK: - EMChatManagerDelegate
extension KDYChatHelper: EMChatManagerDelegate {
    /**
     *  会话列表发生更新
     */
    private func conversationListDidUpdate(_ aConversationList: [AnyObject]!) {
        if (self.mainTabbarVC != nil) {
            self.mainTabbarVC!.setupUnReadMessageCount()
        }
        
        if (self.conversationVC != nil) {
            self.conversationVC!.refreshConversations()
        }
    }
    
    /**
     *  收到 EMMessage消息
     */
    private func messagesDidReceive(_ aMessages: [AnyObject]!) {
        
        for message in aMessages as! [EMMessage] {    
            let needPushnotification = (message.chatType == EMChatTypeChat)
            if needPushnotification {
#if !TARGET_IPHONE_SIMULATOR
                let applicationState = UIApplication.shared.applicationState
                
                switch applicationState {
                case .active, .inactive:
                    if (self.mainTabbarVC != nil) {
                        self.mainTabbarVC!.playSoundAndVibration()
                    }
                case .background:
                    if (self.mainTabbarVC != nil) {
                        self.mainTabbarVC!.showNotificationWithMessage(message)
                    }
                }
#endif
            }
        
            if (self.conversationVC != nil) {
                self.conversationVC!.refreshConversations()
            }
            
            if (self.mainTabbarVC != nil) {
                self.mainTabbarVC!.setupUnReadMessageCount()
            }
        }
    }
}

// MARK: - EMContactManagerDelegate
extension KDYChatHelper: EMContactManagerDelegate {
    
    /**
     *  对方同意加好友
     */
    func friendRequestDidApprove(byUser aUsername: String!) {
        let messageStr = "\(aUsername)同意了您加好友的申请"
        let alertView = UIAlertView(title: nil, message: messageStr, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    /**
     *  对方拒绝加好友
     */
    func friendRequestDidDecline(byUser aUsername: String!) {
        let messageStr = "\(aUsername)拒绝了您加好友的申请"
        let alertView = UIAlertView(title: nil, message: messageStr, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    /**
     *  建立双方好友关系
     */
    func friendshipDidAdd(byUser aUsername: String!) {
        
    }
    
    /**
     *  解除双方好友关系
     */
    func friendshipDidRemove(byUser aUsername: String!) {
        
    }
    
    /**
     *  收到对方申请加好友的消息
     */
    func friendRequestDidReceive(fromUser aUsername: String!, message aMessage: String!) {
        
    }
}

// MARK: - EMGroupManagerDelegate
extension KDYChatHelper: EMGroupManagerDelegate {
    
}

