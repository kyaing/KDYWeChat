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
        return UIScreen.mainScreen().bounds.size
    }
    
    class var width: CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class var height: CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
}

