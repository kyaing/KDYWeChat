//
//  MBProgressHUD+Loading.swift
//  KDYWeChat
//
//  Created by mac on 16/11/22.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    
    //    HUD.mode = MBProgressHUDModeIndeterminate;//菊花，默认值
    //    HUD.mode = MBProgressHUDModeDeterminate;//圆饼，饼状图
    //    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;//进度条
    //    HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
    //    HUD.mode = MBProgressHUDModeCustomView; //需要设置自定义视图时候设置成这个
    //    HUD.mode = MBProgressHUDModeText; //只显示文本
    
    /**
     *  显示提示信息
     */
    class func showHUD(text: String, mode: MBProgressHUDMode, toView view: UIView) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.label.text = text
        hud.label.font = UIFont.systemFontOfSize(13)
        hud.mode = mode
        hud.removeFromSuperViewOnHide = true
        hud.hideAnimated(true, afterDelay: 0.5)
    }
    
    class func hideHUD(view: UIView) {
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
}

