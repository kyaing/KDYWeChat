//
//  UIViewController+Extension.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
}

extension UIViewController {
    
    // Nib
    class func initFromNib() -> UIViewController {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter")
            return UIViewController()
        }
        
        return self.init(nibName: self.nameOfClass, bundle: nil)
    }

    // Push
    public func kyPushAndHideTabbar(_ viewController: UIViewController) {
        kyPushViewController(viewController, animated: true, hideTabbar: true)
    }
    
    fileprivate func kyPushViewController(_ viewController: UIViewController, animated: Bool, hideTabbar: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func kyPushViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    // Present
    public func kyPresentViewController(_ viewController: UIViewController, animated: Bool, completion: (()->Void)?) {
        let navigation = UINavigationController(rootViewController: viewController)
        self.present(navigation, animated: animated, completion: completion)
    }
    
    // Pop 
    public func kyPopViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    // Notification
    public func postNotificationName(_ name: String) {
        postNotificationName(name, object: nil)
    }
    
    public func postNotificationName(_ name: String, object: AnyObject?) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: object, userInfo: nil)
    }
    
    public func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    public func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    public func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

