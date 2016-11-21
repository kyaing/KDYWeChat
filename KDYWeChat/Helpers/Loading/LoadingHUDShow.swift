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
    
    //    HUD.mode = MBProgressHUDModeIndeterminate;//菊花，默认值
    //    HUD.mode = MBProgressHUDModeDeterminate;//圆饼，饼状图
    //    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;//进度条
    //    HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
    //    HUD.mode = MBProgressHUDModeCustomView; //需要设置自定义视图时候设置成这个
    //    HUD.mode = MBProgressHUDModeText; //只显示文本
    
    var hud: MBProgressHUD!
    
    static let shareInstance = LoadingHUDShow()
    
    // MARK: - Life Cycle
    private override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    /**
     *  显示加载状态
     */
    func showLodingWithStatus(status: String, view: UIView) {
        showSVProgressHUD(.Loding, view: view, status: status)
    }
    
    /**
     *  显示成功状态
     */
    func showSuccessWithStatus(status: String, view: UIView) {
        showSVProgressHUD(.Success, view: view, status: status)
    }
    
    /**
     *  显示失败状态
     */
    func showErrorWithStatus(status: String, view: UIView) {
        showSVProgressHUD(.Error, view: view, status: status)
    }
    
    func hideHUD() {
        
    }
    
    func setupProgressHUD(view: UIView) {
        self.hud = MBProgressHUD(view: view)
        self.hud.label.font = UIFont.systemFontOfSize(13)
        self.hud.center = view.center
        self.hud.mode = .Indeterminate
        self.hud.label.text = "加载中..."
        view.addSubview(self.hud)
        self.hud.showAnimated(true)
    }
    
    func showSVProgressHUD(loadingType: LodingHUDType, view superView: UIView, status hudStatus: String? = nil) {
        setupProgressHUD(superView)
        
        switch loadingType {
        case .Loding:
            MBProgressHUD.showHUDAddedTo(superView, animated: true)
            break
            
        case .Success: break
            
        case .Error: break
            
        }
    }
}

