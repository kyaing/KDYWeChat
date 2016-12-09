//
//  UserInfoManager.swift
//  KDYWeChat
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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

func dicConvertToJsonString(_ dic: NSMutableDictionary) -> String {
    let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: [])
    let jsonStr = String(data: jsonData!, encoding: String.Encoding.utf8)!
    print("jsonStr = \(jsonStr)")
    
    return jsonStr
}

func jsonStringConvertToDic(_ jsonStr: String) -> NSDictionary {
    var dic = NSDictionary()
    let jsonData = jsonStr.data(using: String.Encoding.utf8)
    dic = try! JSONSerialization.jsonObject(with: jsonData!, options: []) as! NSDictionary
    
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
        
        if let avatorFile = user.object(forKey: kAvatarImage) as? AVFile {
            self.imageUrl = avatorFile.url
        }
        
        if let nickname = user.object(forKey: kNickname) as? String {
            self.nickname = nickname
        }
        
        if let gender = user.object(forKey: kGender) as? String {
            self.gender = gender
        }
        
        if let location = user.object(forKey: kLocation) as? String {
            self.location = location
        }
        
        if let jsonStr = user.object(forKey: kAlumbJson) as? String {
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
    fileprivate override init() {
        super.init()
        initUsers()
    }
    
    typealias successAction = (_ success: Bool) -> Void
    typealias failureAction = (_ error: NSError) -> Void
    
    /**
     *  查询LeanCloud 所有用户
     */
    func initUsers() {
        self.users.removeAllObjects()
        let userQuery = AVQuery(className: kUserClass)
        
        // 异步查询，存储所有用户 (# 这里要优化！应该查当前用户的所有好友再存储)
        userQuery?.findObjectsInBackground { (objects, error) in
            
            guard objects != nil && objects?.count > 0 else { return }
            
            for object in objects as! [AVUser] {
                let userInfo = UserInfoEntity(user: object)
                if userInfo.username?.characters.count > 0 {
                    self.users.setObject(userInfo, forKey: userInfo.username! as NSCopying)
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
    func uploadUserAvatorInBackground(_ image: UIImage,
                                      successs: @escaping successAction,
                                      failures: @escaping failureAction) {
        
        var imageData: Data?
        if UIImagePNGRepresentation(image) == nil {
            imageData = UIImageJPEGRepresentation(image, 0.5)!
        } else {
            imageData = UIImagePNGRepresentation(image)!
        }
        
        if imageData != nil {
            let currentUser = AVUser.current()
            let avatorFile = AVFile(data: imageData)
            avatorFile?.saveInBackground()
    
            currentUser?.setObject(avatorFile, forKey: kAvatarImage)
            currentUser?.saveInBackground { (success, error) in
                if success {
                    let userinfo = UserInfoEntity(user: currentUser!)
                    self.users.setObject(userinfo, forKey: userinfo.username! as NSCopying)
                    
                    successs(success)
                    
                } else {
                    failures(error as! NSError)
                }
            }
        }
    }
    
    /**
     *  上传用户昵称
     */
    func uploadUserNicknameInBackground(_ nickname: String,
                                        successs: @escaping successAction,
                                        failures: @escaping failureAction) {
        
        let currentUser = AVUser.current()
        currentUser?.setObject(nickname, forKey: kNickname)
        currentUser?.saveInBackground { (success, error) in
            if success {
                let userinfo = UserInfoEntity(user: currentUser!)
                self.users.setObject(userinfo, forKey: userinfo.username! as NSCopying)
                
                successs(success)
                
            } else {
                failures(error as! NSError)
            }
        }
    }
    
    /**
     *  获取用户信息 by frineds
     */
    func getUserInfoInBackgroundWithFriends(_ friends: [AnyObject],
                                            success: successAction,
                                            failure: failureAction) {
        
    }
    
    /**
     *  获取当前用户信息
     */
    func getCurrentUserInfo() -> UserInfoEntity? {
        if AVUser.current().username != nil {
            if let userInfo = self.users.object(forKey: AVUser.current().username) {
                return userInfo as? UserInfoEntity
            }
        }
        
        return nil
    }
    
    /**
     *  获取用户信息，by 用户名
     */
    func getUserInfoByName(_ username: String) -> UserInfoEntity? {
        if let userInfo = self.users.object(forKey: username) {
            return userInfo as? UserInfoEntity
        }
        
        return nil
    }
    
    /**
     *  发表个人动态
     */
    func publishAlumbInfomation(_ time: String,
                                text: String,
                                images: [UIImage],
                                successs: @escaping successAction,
                                failures: @escaping failureAction) {
        
        let currentUser  = AVUser.current()
        let alumbinfoDic = NSMutableDictionary()  // 单条动态
        let imagesArray  = NSMutableArray()       // 照片数组
        
        let avatarUrl: String
        if let avatorFile = currentUser?.object(forKey: kAvatarImage) as? AVFile {
            avatarUrl = avatorFile.url
        } else {
            avatarUrl = ""
        }
        
        for image in images {
            var imageData: Data?
            if UIImagePNGRepresentation(image) == nil {
                imageData = UIImageJPEGRepresentation(image, 0.5)!
            } else {
                imageData = UIImagePNGRepresentation(image)!
            }
            
            let imageDic = NSMutableDictionary()
            imageDic.setObject(String(format: "%@", imageData! as CVarArg), forKey: kImageUrl as NSCopying)
            
            imagesArray.add(imageDic)
        }
        
        alumbinfoDic.setObject(time, forKey: kTime as NSCopying)
        alumbinfoDic.setObject(avatarUrl, forKey: kAvatarImage as NSCopying)
        alumbinfoDic.setObject(currentUser!.username, forKey: kNickname as NSCopying)
        alumbinfoDic.setObject(text, forKey: kContentText as NSCopying)
        // alumbinfoDic.setObject(imagesArray, forKey: kImageArray)  // 先不处理图片
        
        currentUser?.setObject(dicConvertToJsonString(alumbinfoDic), forKey: kAlumbJson)
        
        currentUser?.saveInBackground({ (success, error) in
            if success {
                let userinfo = UserInfoEntity(user: currentUser!)
                self.users.setObject(userinfo, forKey: userinfo.username! as NSCopying)

                successs(success)

            } else {
                failures(error as! NSError)
            }
        })
    }
}

