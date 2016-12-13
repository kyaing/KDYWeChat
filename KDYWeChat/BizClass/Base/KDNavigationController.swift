//
//  KDNavigationController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/11.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 自定义导航栏
class KDNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupNavigationBar()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 添加返回手势
        self.interactivePopGestureRecognizer?.isEnabled = true
        
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            // 自定义返回按钮
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "main_back"), for: UIControlState())
            button.addTarget(self, action: #selector(self.backItemAction), for: .touchUpInside)
            button.frame.size = (button.currentBackgroundImage?.size)!
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }
        
        super.pushViewController(viewController, animated: animated)
    }

    func setupNavigationBar() {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        UINavigationBar.appearance().barTintColor = UIColor(colorHex: KDYColor.barTintColor.rawValue)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        UINavigationBar.appearance().isTranslucent = true
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
                [NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                NSForegroundColorAttributeName: UIColor.white],
                for: UIControlState())
    }
    
    func backItemAction() {
        self.popViewController(animated: true)
    }
}

