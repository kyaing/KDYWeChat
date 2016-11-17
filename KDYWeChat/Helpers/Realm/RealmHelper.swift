//
//  RealmHelper.swift
//  KDYWeChat
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import RealmSwift

let messagesRealm = "messages.realm"
let contactsRealm = "contacts.realm"

class RealmHelper: NSObject {
    
    static let shareInstance = RealmHelper()
    private override init() {}
    
    /**
     *  初始化Realm
     */
    func setupRealm(realmName: String) -> Realm {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent(realmName)
        
        let realm = try! Realm(configuration: config)
        
        return realm
    }
}

