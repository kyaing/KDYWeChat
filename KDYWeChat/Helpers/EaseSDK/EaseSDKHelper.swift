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
    private override init() {}
    
    // MARK: - Init SDK
    func hyphenateApplication(application: UIApplication,
                              launchOptions: [NSObject: AnyObject]?,
                              appkey: String,
                              apnsCerName: String,
                              otherConfig: [NSObject: AnyObject]?) {
        
        self.setupAppDelegateNotifiction()
        self.registerRemoteNotification()
        
        // 配置SDK
        let options = EMOptions(appkey: appkey)
        options.apnsCertName = apnsCerName
        options.isAutoAcceptGroupInvitation = false
        options.enableConsoleLog = true

        EMClient.sharedClient().initializeSDKWithOptions(options)
    }
    
    // MARK: - Private Methods
    /**
     *  注册Appdelegate的通知
     */
    func setupAppDelegateNotifiction() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.appDidEnterBackgroundNotif(_:)),
                                                         name: UIApplicationDidEnterBackgroundNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.appWillEnterForegroundNotif(_:)),
                                                         name: UIApplicationWillEnterForegroundNotification,
                                                         object: nil)
    }
    
    func appDidEnterBackgroundNotif(notification: NSNotification) {
        // 进入后台时断开SDK
        EMClient.sharedClient().applicationDidEnterBackground(notification.object)
    }
    
    func appWillEnterForegroundNotif(notification: NSNotification) {
        // 即将进入前台时连接SDK
        EMClient.sharedClient().applicationWillEnterForeground(notification.object)
    }
    
    /**
     *  注册远程通知
     */
    func registerRemoteNotification() {
        let application = UIApplication.sharedApplication()
        application.applicationIconBadgeNumber = 0

        if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            let notificationTypes: UIUserNotificationType =
                UIUserNotificationType(rawValue: UIUserNotificationType.Badge.rawValue |
                UIUserNotificationType.Sound.rawValue |
                UIUserNotificationType.Alert.rawValue)
            
            let settting: UIUserNotificationSettings = UIUserNotificationSettings.init(forTypes: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settting)
            
            if application.respondsToSelector(#selector(UIApplication.registerForRemoteNotifications)) {
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
    
    // MARK: - Send Message
    /**
     * 发送文本消息
     
     - parameter text:        文本内容
     - parameter toUser:      接收者
     - parameter messageType: 聊天类型
     - parameter messageExt:  消息扩展
     
     - returns: 返回 EmMessage 的文本消息
     */
    func sendTextMessage(text: String,
                         toUser: String,
                         messageType: EMChatType,
                         messageExt: [NSObject: AnyObject]!) -> EMMessage? {
        
        let textBody         = EMTextMessageBody(text: text)
        let from             = EMClient.sharedClient().currentUsername
        let textMessage      = EMMessage(conversationID: toUser,
                                         from: from,
                                         to: toUser,
                                         body: textBody,
                                         ext: messageExt)
        textMessage.chatType = messageType

        return textMessage
    }
    
    /**
     *  发送图片消息
     */
    func sendImageMessageWithImage(image: UIImage,
                                   toUser: String,
                                   messageType: EMChatType,
                                   messageExt: [NSObject: AnyObject]!) -> EMMessage? {
        
        let data              = UIImageJPEGRepresentation(image, 1)
        let imageBody         = EMImageMessageBody(data: data, displayName: "image.png")
        let from              = EMClient.sharedClient().currentUsername
        let imageMessage      = EMMessage(conversationID: toUser,
                                          from: from,
                                          to: toUser,
                                          body: imageBody,
                                          ext: messageExt)
        imageMessage.chatType = messageType
        
        return imageMessage
    }
    
    /**
     *  发送语音消息
     */
    func sendVoiceMessageWithLocalPath(path: String,
                                       duration: Int32,
                                       toUser: String,
                                       messageType: EMChatType,
                                       messageExt: [NSObject: AnyObject]!) -> EMMessage? {
    
        let vocieBody         = EMVoiceMessageBody(localPath: path, displayName: "voice")
        let from              = EMClient.sharedClient().currentUsername
        let vocieMessage      = EMMessage(conversationID: toUser,
                                          from: from,
                                          to: toUser,
                                          body: vocieBody,
                                          ext: messageExt)
        vocieBody.duration    = duration
        vocieMessage.chatType = messageType
        
        return vocieMessage
    }
    
    /**
     *  发送位置消息
     */
    func sendLocationMessageWithLatitude(latitude: Double,
                                         longitude: Double,
                                         address: String,
                                         toUser: String,
                                         messageType: EMChatType,
                                         messageExt: [NSObject: AnyObject]!) -> EMMessage? {
        
        let locationBody = EMLocationMessageBody(latitude: latitude, longitude: longitude, address: address)
        let from = EMClient.sharedClient().currentUsername
        let locationMessage = EMMessage(conversationID: toUser,
                                        from: from,
                                        to: toUser,
                                        body: locationBody,
                                        ext: messageExt)
        locationMessage.chatType = messageType
        
        return locationMessage
    }
}

