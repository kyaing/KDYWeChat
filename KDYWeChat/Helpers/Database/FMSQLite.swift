//
//  FMSQLite.swift
//  KDYWeChat
//
//  Created by mac on 16/11/28.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import AVOSCloud
import FMDB

/// 封装 FMDB
class FMSQLite: NSObject {
    
    // 数据库对象
    var db: FMDatabase!
    static let shareInstance = FMSQLite()
    
    private override init() {
        super.init()
    }
    
    deinit {
        if self.db.open() {
            self.db.close()
        }
    }
    
    // MARK: - Operations
    
    /**
     *  打开数据库
     */
    func openDB() {
        let fileName = AVUser.currentUser().username
        let fileURL = try! NSFileManager.defaultManager()
            .URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            .URLByAppendingPathComponent("\(fileName).sqlite")
        
        self.db = FMDatabase(path: fileURL.path)
        
        createTable()
    }

    func createTable() {
        if !self.db.open() {
            print("Unable to open database")
            return
        }
        
        do {
            try self.db.executeUpdate("create table t_conversation(nickname, lastContent, avatarURLPath, avatarData, time)", values: nil)
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        self.db.close()
    }
    
    /**
     *  更新数据
     */
    func updateTable(model: MessageDBModel) {
        if !self.db.open() {
            return
        }
        
        do {
            if let avatarData = model.avatarData {
                try self.db.executeUpdate("insert into t_conversation(nickname, lastContent, avatarURLPath, avatarData, time) values(?, ?, ?, ?, ?);", values: [model.nickname, model.lastContent, model.avatarURLPath, avatarData, model.time])
                
            } else {
                try self.db.executeUpdate("insert into t_conversation(nickname, lastContent, avatarURLPath, avatarData, time) values(?, ?, ?, ?, ?);", values: [model.nickname, model.lastContent, model.avatarURLPath, "", model.time])
            }
            
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        self.db.close()
    }
}

