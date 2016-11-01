//
//  KDChatLocationViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// 地理位置页面
class KDChatLocationViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "位置"
        self.view.backgroundColor = UIColor.whiteColor()
    
        // 导航栏按钮
        seupBarButtons()
    }
    
    func seupBarButtons() {
        let leftBarItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(self.leftBarButtonAction))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem(title: "确定", style: .Plain, target: self, action: #selector(self.rightBarButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    // MARK: - Event Response 
    func leftBarButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightBarButtonAction() {
        // 当定位成功后，设置确定按钮可用
        
    }
}

