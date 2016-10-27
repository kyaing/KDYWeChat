//
//  UserInfoManager.swift
//  KDYWeChat
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

// _User 表中新添加的字段
let kUserClass   = "_User"
let kAvatorImage = "avatorImage"
let kGender      = "gender"
let kLocation    = "location"

/// 用户信息实体类
class UserInfoEntity: NSObject {
    
    var objectId: String?
    var username: String?   // 用户名
    var nickname: String?   // 昵称(备注名)
    var imageUrl: String?   // 头像地址
    var gender:   String?   // 性别
    var location: String?   // 地区
    
    // 初始化
    init(user: AVUser) {
        super.init()
        
        
    }
}

/// 用户信息管理类
class UserInfoManager: NSObject {
    
    let users: NSMutableDictionary = [:]
    let kCurrentUsername = AVUser.currentUser().username
    
    static let shareInstance = UserInfoManager()
    private override init() {
        super.init()
    }
    
    typealias successAction = (success: Bool) -> Void
    typealias failureAction = (error: NSError) -> Void

    // MARK: - Public Methods
    /**
     *  上传用户头像
     */
    func uploadUserAvatorInBackground(image: UIImage, success: successAction, failure: failureAction) {
        
        var imageData: NSData?
        if UIImagePNGRepresentation(image) == nil {
            imageData = UIImageJPEGRepresentation(image, 1.0)!
        } else {
            imageData = UIImagePNGRepresentation(image)!
        }
        
        if imageData != nil {
            let currentUser = AVUser.currentUser()
            let avatorFile = AVFile(data: imageData)
            avatorFile.saveInBackground()
            
            currentUser.setObject(avatorFile, forKey: kAvatorImage)
            currentUser.saveInBackgroundWithBlock({ (success, error) in
                if success {
                    print("上传头像成功")
                    
                } else {
                    print("上传头像失败：\(error.description)")
                }
            })
        }
    }
    
    /**
     *  上传用户信息
     */
    
    /**
     *  获取用户信息
     */
    
    /**
     *  获取用户信息 by frineds
     */
    func getUserInfoInBackgroundWithFriends(friends: [AnyObject], success: successAction, failure: failureAction) {
        
    }
    
    /**
     *  获取用户信息 by username
     */
    func getUserInfoInBackground(usenames: [AnyObject]) {
        let query = AVQuery(className: "_User")
        query.whereKey(kCurrentUsername, containedIn: usenames)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            
        }
    }
    
    // MARK: - Private Methods
    func test() {
        
    }
}

