//
//  LoadingProgressHUD.swift
//  KDYWeChat
//
//  Created by mac on 16/11/21.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import MBProgressHUD

class LoadingHUDShow: NSObject {
    
    enum LodingHUDType {
        case loding
        case success
        case error
    }
    
    var hud: MBProgressHUD!
    
    static let shareInstance = LoadingHUDShow()
    
    // MARK: - Life Cycle
    fileprivate override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    func showHUDWithText(_ text: String, toView: UIView) {
        MBProgressHUD.showHUD(text, mode: .indeterminate, toView: toView)
    }
    
    func hideHUD(_ toView: UIView) {
        MBProgressHUD.hideHUD(toView)
    }
}

