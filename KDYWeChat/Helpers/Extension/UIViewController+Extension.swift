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
    
    // Present
    public func ky_presentViewController(viewController: UIViewController, animated: Bool, completion: (()->Void)?) {
        let navigation = UINavigationController(rootViewController: viewController)
        self.presentViewController(navigation, animated: animated, completion: completion)
    }
    
    // Pop 
    public func ky_popViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

