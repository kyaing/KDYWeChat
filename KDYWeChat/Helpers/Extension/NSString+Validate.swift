//
//  NSString+Validate.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/15.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

extension NSString {
    /**
     *  检测邮箱格式
     */
    class func validateEmail(mail: String) -> Bool {
        return true
    }
    
    /**
     *  检测手机号格式
     */
    class func isPhoneNumber(phoneNumber: String) -> Bool {
        if phoneNumber.characters.count == 0 {
            return false
        }
        
        let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        
        if regexMobile.evaluateWithObject(mobile) == true {
            return true
        } else {
            return false
        }
    }
}

