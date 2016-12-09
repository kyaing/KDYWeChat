//
//  AppDelegate.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/8.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbarController: KDTabBarController?
    var mainTabbarVC: KDTabBarController?
    
    // MARK: - AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
    
        // 初始化 LeanCloud
        setupLeanCloud(application, launchOptions: launchOptions)
        
        // 初始化 EaseSDK
        setupEmSDK(application, launchOptions: launchOptions)
    
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // App进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }
    
    // App将要进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }
    
    // App准备激活
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    // 接收远程通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if (self.mainTabbarVC != nil) {
            self.mainTabbarVC!.jumpToConversationListVC()
        }
    }
    
    // 接收本地通知
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        UIApplication.shared.cancelAllLocalNotifications()
        
        if (self.mainTabbarVC != nil) {
            self.mainTabbarVC!.didReceviedLocalNotification(notification)
        }
    }
    
    // MARK: - Private Methods
    func setupEmSDK(_ application: UIApplication, launchOptions: [AnyHashable: Any]?) {
        
        let apnsCerName: String = emApnsDevCerName
        easemobApplication(application,
                           launchOptions: launchOptions,
                           appKey: emAppKey,
                           apnsCerName: apnsCerName,
                           otherConfig: nil)
    }
    
    func setupLeanCloud(_ application: UIApplication, launchOptions: [AnyHashable: Any]?) {
        leanCloundApplication(application, launchOptions: launchOptions)
    }
}

