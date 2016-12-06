//
//  LoginViewModel.swift
//  KDYWeChat
//
//  Created by mac on 16/11/22.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Validator

class LoginViewModel {
    
    // MARK: - Parameters
    
    /// 是否登录的序列
    let loginBtnEnabled: Driver<Bool>
    
    /// 验证用户名的序列
    let validatedUsername: Driver<ValidationResult>
    
    /// 验证密码的序列
    let validatedPassword: Driver<ValidationResult>
    
    // MARK: - Life Cycle
    init(input: (username: Driver<String>, password: Driver<String>)) {
        
        validatedUsername = input.username
            .map { usernameString in
                let usernameRule = ValidationRuleLength(min: 1, max: 50,
                    failureError: ValidationError(message: "Invalid Username"))
                return usernameString.validate(rule: usernameRule)
            }
        
        validatedPassword = input.password
            .map { passwordString in
                let passwordRule = ValidationRuleLength(min: 6, max: 50,
                    failureError: ValidationError(message: "Invalid Password"))
                return passwordString.validate(rule: passwordRule)
            }
        
        loginBtnEnabled = Driver
            .combineLatest(validatedUsername, validatedPassword) { username, password in
                return username.isValid && password.isValid
            }
            .distinctUntilChanged()
    }
}

