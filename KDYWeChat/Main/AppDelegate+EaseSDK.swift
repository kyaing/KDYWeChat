//
//  AppDelegate+EaseSDK.swift
//  KDYWeChat
//
//  Created by mac on 16/9/30.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    /**
     *  配置环信sdk
     */
    func easemobApplication(_ application: UIApplication,
                            launchOptions: [AnyHashable: Any]?,
                            appKey: String,
                            apnsCerName: String,
                            otherConfig: [AnyHashable: Any]?) {
        
        // 登录状态通知
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.loginStateChanged(_:)),
                                                         name: NSNotification.Name(rawValue: kLoginStateChangedNoti),
                                                         object: nil)
        
        // 初始化sdk
        EaseSDKHelper.shareInstance.hyphenateApplication(application,
                                                         launchOptions: launchOptions,
                                                         appkey: appKey,
                                                         apnsCerName: apnsCerName,
                                                         otherConfig: nil)
        
        // 初始化 KDYWeChatHelper 单例类
        KDYWeChatHelper.shareInstance.initHeapler()
        
        // 根据用户是否自动登录，来发送登录状态的通知
        let isAutoLogin = EMClient.shared().isAutoLogin
        if isAutoLogin {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kLoginStateChangedNoti), object: NSNumber(value: true as Bool))
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kLoginStateChangedNoti), object: NSNumber(value: false as Bool))
        }
    }
    
    /**
     *  登录状态改变
     */
    func loginStateChanged(_ notification: Notification) {
        var navigationController: KDNavigationController?
        
        // 根据登录状态的不同，设置不同的根控制器
        let loginState = (notification.object as AnyObject).boolValue

        if loginState! {   // 登录成功，切换到tabbar
            if self.mainTabbarVC == nil {
                self.mainTabbarVC = KDTabBarController()
            }
            
            // 用户体系
            initLeanCloud()
            
            KDYWeChatHelper.shareInstance.mainTabbarVC = self.mainTabbarVC
            
            KDYWeChatHelper.shareInstance.asyncPushOptions()
            KDYWeChatHelper.shareInstance.asyncConversationFromDB()
            
            self.window?.rootViewController = self.mainTabbarVC
            
        } else {   // 登录失败，切换到登录页面
            if mainTabbarVC != nil {
                _ = mainTabbarVC?.navigationController?.popToRootViewController(animated: false)
            }
            
            mainTabbarVC = nil
            KDYWeChatHelper.shareInstance.mainTabbarVC = nil
            
            let loginController = KDLoginViewController.initFromNib()
            navigationController = KDNavigationController(rootViewController: loginController)
            
            self.window?.rootViewController = navigationController
        }
    }
    
    // MARK: - AppDelegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知成功，交给SDK并绑定
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            EMClient.shared().bindDeviceToken(deviceToken)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
#if TARGET_IPHONE_SIMULATOR
        // 注册远程通知失败，若有失败看看环境配置或证书是否有误！
        let alertView = UIAlertView.init(title: "注册APN失败",
                                         message: error.debugDescription,
                                         delegate: nil,
                                         cancelButtonTitle: "确定"
                                         )
        alertView.show()
#endif
    }
}

