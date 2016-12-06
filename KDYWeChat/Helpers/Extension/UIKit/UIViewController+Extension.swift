//
//  UIViewController+Extension.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last! as String
    }
}

extension UIViewController {
    
    // Nib
    class func initFromNib() -> UIViewController {
        let hasNib: Bool = NSBundle.mainBundle().pathForResource(self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter")
            return UIViewController()
        }
        
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }

    // Push
    public func ky_pushAndHideTabbar(viewController: UIViewController) {
        ky_pushViewController(viewController, animated: true, hideTabbar: true)
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

extension UIViewController {
    // Noti
    public func postNotificationName(name: String) {
        postNotificationName(name, object: nil)
    }
    
    public func postNotificationName(name: String, object: AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: nil)
    }
    
    public func addNotificationObserver(name: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: name, object: nil)
    }
    
    public func removeNotificationObserver(name: String) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: name, object: nil)
    }
    
    public func removeNotificationObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

