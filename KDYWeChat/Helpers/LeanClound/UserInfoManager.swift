//
//  UserInfoManager.swift
//  KDYWeChat
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

/// _User 表
let kUserClass     = "_User"

/**
 *  _User 表中某些的字段
 */
/// 头像
let kAvatarImage = "avatar"
/// 昵称
let kNickname    = "nickName"
/// 性别
let kGender      = "gender"
/// 所有地区
let kLocation    = "location"

/// 个人动态 (存储着字典数组)
let kAlumbJson   = "alumbsJson"

/// 时间
let kTime        = "time"
/// 朋友圈正文
let kContentText = "text"
/// 朋友图图片
let kImageUrl    = "imageUrl"
/// 朋友圈所有图片
let kImageArray  = "images"
/**
[
    {
        "time": "2016-11-11",
        "avatar": ""
        "nickname": "昵称"
        "text": "内容1",
        "images": [
            {
                "url": "fdsa" (AVFile)
            },
            {
                "url": "com"
            }
        ]
    },
    {
        "time": "2016-11-13"
        "avatar": ""
        "nickname": "昵称"
        "text": "内容2",
        "images": [
        {
            "url": "fdsafdsa"
        }
        ]
    }
]
*/

func dicConvertToJsonString(dic: NSMutableDictionary) -> String {
    let jsonData = try? NSJSONSerialization.dataWithJSONObject(dic, options: [])
    let jsonStr = String(data: jsonData!, encoding: NSUTF8StringEncoding)!
    print("jsonStr = \(jsonStr)")
    
    return jsonStr
}

func jsonStringConvertToDic(jsonStr: String) -> NSDictionary {
    var dic = NSDictionary()
    let jsonData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
    dic = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: []) as! NSDictionary
    
    return dic
}

/// 用户信息实体类
class UserInfoEntity: NSObject {
    
    var objectId: String!   // key
    var username: String!   // 用户名
    var nickname: String?   // 昵称(备注名)
    var imageUrl: String?   // 头像地址
    var gender:   String?   // 性别
    var location: String?   // 地区
    var alumbs: NSDictionary? // 个人动态
    
    // 初始化实体类
    init(user: AVUser) {
        super.init()
        
        self.objectId = user.objectId
        self.username = user.username
        
        if let avatorFile = user.objectForKey(kAvatarImage) as? AVFile {
            self.imageUrl = avatorFile.url
        }
        
        if let nickname = user.objectForKey(kNickname) as? String {
            self.nickname = nickname
        }
        
        if let gender = user.objectForKey(kGender) as? String {
            self.gender = gender
        }
        
        if let location = user.objectForKey(kLocation) as? String {
            self.location = location
        }
        
        if let jsonStr = user.objectForKey(kAlumbJson) as? String {
            self.alumbs = jsonStringConvertToDic(jsonStr)
        }
    }
}

/// 用户信息管理类
class UserInfoManager: NSObject {
    
    // _User 中的所有用户
    let users: NSMutableDictionary = [:]
    
    static let shareInstance = UserInfoManager()
    
    // MARK: - Life Cycle
    private override init() {
        super.init()
        initUsers()
    }
    
    typealias successAction = (success: Bool) -> Void
    typealias failureAction = (error: NSError) -> Void
    
    /**
     *  查询LeanCloud 所有用户
     */
    func initUsers() {
        self.users.removeAllObjects()
        let userQuery = AVQuery(className: kUserClass)
        
        // 异步查询，存储所有用户 (# 这里要优化！应该查当前用户的所有好友再存储)
        userQuery.findObjectsInBackgroundWithBlock { (objects, error) in
            
            guard objects != nil && objects.count > 0 else { return }
            
            for object in objects as! [AVUser] {
                let userInfo = UserInfoEntity(user: object)
                if userInfo.username?.characters.count > 0 {
                    self.users.setObject(userInfo, forKey: userInfo.username!)
                }
            }
        }
    }
    
    /**
     *  清除所有用户
     */
    func clearUsers() {
        
    }
    
    // MARK: - Operation
    /**
     *  上传用户头像
     */
    func uploadUserAvatorInBackground(image: UIImage,
                                      successs: successAction,
                                      failures: failureAction) {
        
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
    
            currentUser.setObject(avatorFile, forKey: kAvatarImage)
            currentUser.saveInBackgroundWithBlock({ (success, error) in
                if success {
                    let userinfo = UserInfoEntity(user: currentUser)
                    self.users.setObject(userinfo, forKey: userinfo.username!)
                    
                    successs(success: success)
                    
                } else {
                    failures(error: error)
                }
            })
        }
    }
    
    /**
     *  上传用户信息
     */
    
    /**
     *  获取用户信息 by frineds
     */
    func getUserInfoInBackgroundWithFriends(friends: [AnyObject],
                                            success: successAction,
                                            failure: failureAction) {
        
    }
    
    /**
     *  获取当前用户信息
     */
    func getCurrentUserInfo() -> UserInfoEntity? {
        if AVUser.currentUser().username != nil {
            if let userInfo = self.users.objectForKey(AVUser.currentUser().username) {
                return userInfo as? UserInfoEntity
            }
        }
        
        return nil
    }
    
    /**
     *  获取用户信息，by 用户名
     */
    func getUserInfoByName(username: String) -> UserInfoEntity? {
        if let userInfo = self.users.objectForKey(username) {
            return userInfo as? UserInfoEntity
        }
        
        return nil
    }
    
    /**
     *  发表个人动态
     */
    func publishAlumbInfomation(time: String,
                                text: String,
                                images: [UIImage],
                                successs: successAction,
                                failures: failureAction) {
        
        let currentUser  = AVUser.currentUser()
        let alumbinfoDic = NSMutableDictionary()  // 单条动态
        let imagesArray  = NSMutableArray()       // 照片数组
        
        let avatarUrl: String
        if let avatorFile = currentUser.objectForKey(kAvatarImage) as? AVFile {
            avatarUrl = avatorFile.url
        } else {
            avatarUrl = ""
        }
        
        for image in images {
            var imageData: NSData?
            if UIImagePNGRepresentation(image) == nil {
                imageData = UIImageJPEGRepresentation(image, 0.5)!
            } else {
                imageData = UIImagePNGRepresentation(image)!
            }
            
            let imageDic = NSMutableDictionary()
            imageDic.setObject(String(format: "%@", imageData!), forKey: kImageUrl)
            
            imagesArray.addObject(imageDic)
        }
        
        alumbinfoDic.setObject(time, forKey: kTime)
        alumbinfoDic.setObject(avatarUrl, forKey: kAvatarImage)
        alumbinfoDic.setObject(currentUser.username, forKey: kNickname)
        alumbinfoDic.setObject(text, forKey: kContentText)
        // alumbinfoDic.setObject(imagesArray, forKey: kImageArray)  // 先不处理图片
        
        currentUser.setObject(dicConvertToJsonString(alumbinfoDic), forKey: kAlumbJson)
        
        currentUser.saveInBackgroundWithBlock({ (success, error) in
            if success {
                let userinfo = UserInfoEntity(user: currentUser)
                self.users.setObject(userinfo, forKey: userinfo.username!)

                successs(success: success)

            } else {
                failures(error: error)
            }
        })
    }
}

