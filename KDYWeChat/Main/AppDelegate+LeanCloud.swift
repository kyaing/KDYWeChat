//
//  AppDelegate+LeanCloud.swift
//  KDYWeChat
//
//  Created by mac on 16/9/30.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import AVOSCloud

extension AppDelegate {
    
    /**
     *  初始化 LeanClound 
     *  (因环信不维护用户体系，所以采用LeanClound服务，来管理用户系统；以后再逐渐再加入其它功能)
     */
    func leanCloundApplication(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        
        AVOSCloud.setApplicationId(leanCloudAppId, clientKey: leanCloudAppKey)
        AVOSCloud.setAllLogsEnabled(true)
    }
    
    func initLeanClound() {
        
    }
    
    func clearLeanClound() {
        
    }
}

