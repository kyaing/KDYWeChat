//
//  EaseSDKHelper.swift
//  KDYWeChat
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

class EaseSDKHelper: NSObject, EMClientDelegate {

    // 注意Swift单例的定义方法
    // 这个位置使用 static，static修饰的变量会懒加载
    static let shareInstance = EaseSDKHelper()
    
    // 注意初始化方法应该是私有的，保证单例的真正唯一性！
    fileprivate override init() {}
    
    // MARK: - Init SDK
    func hyphenateApplication(_ application: UIApplication,
                              launchOptions: [AnyHashable: Any]?,
                              appkey: String,
                              apnsCerName: String,
                              otherConfig: [AnyHashable: Any]?) {
        
        self.setupAppDelegateNotifiction()
        self.registerRemoteNotification()
        
        // 配置SDK
        let options = EMOptions(appkey: appkey)
        options?.apnsCertName = apnsCerName
        options?.isAutoAcceptGroupInvitation = false
        options?.enableConsoleLog = true

        EMClient.shared().initializeSDK(with: options)
    }
    
    // MARK: - Private Methods
    /**
     *  注册Appdelegate的通知
     */
    func setupAppDelegateNotifiction() {
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(self.appDidEnterBackgroundNotif(_:)),
                                                         name: NSNotification.Name.UIApplicationDidEnterBackground,
                                                         object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(self.appWillEnterForegroundNotif(_:)),
                                                         name: NSNotification.Name.UIApplicationWillEnterForeground,
                                                         object: nil)
    }
    
    func appDidEnterBackgroundNotif(_ notification: Notification) {
        // 进入后台时断开SDK
        EMClient.shared().applicationDidEnterBackground(notification.object)
    }
    
    func appWillEnterForegroundNotif(_ notification: Notification) {
        // 即将进入前台时连接SDK
        EMClient.shared().applicationWillEnterForeground(notification.object)
    }
    
    /**
     *  注册远程通知
     */
    func registerRemoteNotification() {
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0

        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            let notificationTypes: UIUserNotificationType =
                UIUserNotificationType(rawValue: UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue)
            
            let settting: UIUserNotificationSettings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settting)
            
            if application.responds(to: #selector(UIApplication.registerForRemoteNotifications)) {
                application.registerForRemoteNotifications()
            }
            
            //    #if !TARGET_IPHONE_SIMULATOR
            //        if application.respondsToSelector(#selector(UIApplication.registerForRemoteNotifications)) {
            //            application.registerForRemoteNotifications()
            //            
            //        } else {
            //            let notificationTypes: UIRemoteNotificationType =
            //                UIRemoteNotificationType(rawValue: UIRemoteNotificationType.Badge.rawValue |
            //                UIRemoteNotificationType.Sound.rawValue |
            //                UIRemoteNotificationType.Alert.rawValue)
            //            
            //            UIApplication.sharedApplication().registerForRemoteNotificationTypes(notificationTypes)
            //        }
            //        
            //    #endif
        }
    }
    
    // MARK: - Init Send Message
    /**
     * 初始化文本消息
     
     - parameter text:        文本内容
     - parameter toUser:      接收者
     - parameter messageType: 聊天类型
     - parameter messageExt:  消息扩展
     
     - returns: 返回 EmMessage 的文本消息
     */
    func initSendTextMessage(_ text: String,
                             toUser: String,
                             messageType: EMChatType,
                             messageExt: [AnyHashable: Any]!) -> EMMessage? {
        
        let textBody         = EMTextMessageBody(text: text)
        let from             = EMClient.shared().currentUsername
        let textMessage      = EMMessage(conversationID: toUser,
                                         from: from,
                                         to: toUser,
                                         body: textBody,
                                         ext: messageExt)
        textMessage?.chatType = messageType

        return textMessage
    }
    
    /**
     *  初始化图片消息
     */
    func initSendImageMessageWithImage(_ image: UIImage,
                                       toUser: String,
                                       messageType: EMChatType,
                                       messageExt: [AnyHashable: Any]!) -> EMMessage? {
        
        let data              = UIImageJPEGRepresentation(image, 1)
        let imageBody         = EMImageMessageBody(data: data, displayName: "image.png")
        let from              = EMClient.shared().currentUsername
        let imageMessage      = EMMessage(conversationID: toUser,
                                          from: from,
                                          to: toUser,
                                          body: imageBody,
                                          ext: messageExt)
        imageMessage?.chatType = messageType
        
        return imageMessage
    }
    
    /**
     *  初始化语音消息
     */
    func initSendVoiceMessageWithLocalPath(_ path: String,
                                       duration: Int32,
                                       toUser: String,
                                       messageType: EMChatType,
                                       messageExt: [AnyHashable: Any]!) -> EMMessage? {
    
        let vocieBody         = EMVoiceMessageBody(localPath: path, displayName: "voice")
        let from              = EMClient.shared().currentUsername
        let vocieMessage      = EMMessage(conversationID: toUser,
                                          from: from,
                                          to: toUser,
                                          body: vocieBody,
                                          ext: messageExt)
        vocieBody?.duration    = duration
        vocieMessage?.chatType = messageType
        
        return vocieMessage
    }
    
    /**
     *  初始化位置消息
     */
    func initSendLocationMessageWithLatitude(_ latitude: Double,
                                             longitude: Double,
                                             address: String,
                                             toUser: String,
                                             messageType: EMChatType,
                                             messageExt: [AnyHashable: Any]!) -> EMMessage? {
        
        let locationBody = EMLocationMessageBody(latitude: latitude, longitude: longitude, address: address)
        let from = EMClient.shared().currentUsername
        let locationMessage = EMMessage(conversationID: toUser,
                                        from: from,
                                        to: toUser,
                                        body: locationBody,
                                        ext: messageExt)
        locationMessage?.chatType = messageType
        
        return locationMessage
    }
}

