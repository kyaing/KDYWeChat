//
//  UIViewController+Extension.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

extension UIViewController {
    // Push
    public func ky_pushAndHideTabbar(viewController: UIViewController) {
        self.ky_pushViewController(viewController, animated: true, hideTabbar: true)
    }
    
    private func ky_pushViewController(viewController: UIViewController, animated: Bool, hideTabbar: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func ky_pushViewController(viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    // Pop 
    public func ky_popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

