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
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
    
        // 配置环信
        setupEmSDK(application, launchOptions: launchOptions)
        
        // 配置后端服务
        setupLeanCloud(application, launchOptions: launchOptions)
    
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // App进入后台
    func applicationDidEnterBackground(application: UIApplication) {
        EMClient.sharedClient().applicationDidEnterBackground(application)
    }
    
    // App将要进入前台
    func applicationWillEnterForeground(application: UIApplication) {
        EMClient.sharedClient().applicationWillEnterForeground(application)
    }
    
    // App准备激活
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    // 接收远程通知
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        if (self.mainTabbarVC != nil) {
            self.mainTabbarVC!.jumpToConversationListVC()
        }
    }
    
    // 接收本地通知
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        if (self.mainTabbarVC != nil) {
            self.mainTabbarVC!.didReceviedLocalNotification(notification)
        }
    }
    
    // MARK: - Private Methods
    func setupEmSDK(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        
        let apnsCerName: String = emApnsDevCerName
        self.easemobApplication(application,
                                launchOptions: launchOptions,
                                appKey: emAppKey,
                                apnsCerName: apnsCerName,
                                otherConfig: nil)
    }
    
    func setupLeanCloud(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        self.leanCloundApplication(application, launchOptions: launchOptions)
    }
}

