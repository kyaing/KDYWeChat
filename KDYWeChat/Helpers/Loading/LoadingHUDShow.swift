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
        case Loding
        case Success
        case Error
    }
    
    var hud: MBProgressHUD!
    
    static let shareInstance = LoadingHUDShow()
    
    // MARK: - Life Cycle
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    func showHUDWithText(text: String, toView: UIView) {
        MBProgressHUD.showHUD(text, mode: .Indeterminate, toView: toView)
    }
    
    func hideHUD(toView: UIView) {
        MBProgressHUD.hideHUD(toView)
    }
}

