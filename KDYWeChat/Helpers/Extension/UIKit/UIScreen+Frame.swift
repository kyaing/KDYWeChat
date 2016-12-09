//
//  UIScreen+Frame.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

public extension UIScreen {
    class var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    class var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    class var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
}

