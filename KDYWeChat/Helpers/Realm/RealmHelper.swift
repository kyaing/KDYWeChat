//
//  RealmHelper.swift
//  KDYWeChat
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import RealmSwift
import AVOSCloud

class RealmHelper: NSObject {
    
    static let shareInstance = RealmHelper()
    private override init() {}
    
    /**
     *  初始化Realm
     */
    func setupRealm() -> Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("\(AVUser.currentUser().username).realm")
        
        let realm = try! Realm(configuration: config)
        
        return realm
    }
}

