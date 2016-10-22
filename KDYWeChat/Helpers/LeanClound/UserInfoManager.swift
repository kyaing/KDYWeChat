//
//  UserInfoManager.swift
//  KDYWeChat
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

/// 用户信息管理类
class UserInfoManager: NSObject {
    
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
            
            currentUser.setObject(avatorFile, forKey: "avatorImage")
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
     *  获取好友列表信息
     */
    func getUserInBackgroundWithFriends(friends: NSMutableArray, success: successAction, failure: failureAction) {
        
    }
    
    // MARK: - Private Methods
}

