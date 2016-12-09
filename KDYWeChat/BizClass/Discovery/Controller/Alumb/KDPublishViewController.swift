//
//  KDPublishViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/11/12.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 发动态页面
class KDPublishViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发动态"
        self.view.backgroundColor = UIColor.white
        
        seupBarButtonItems()
    }
    
    func seupBarButtonItems() {
        let leftBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(leftBarButtonAction))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(rightBarButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: - Event Response
    func leftBarButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rightBarButtonAction() {
        
    }
}

