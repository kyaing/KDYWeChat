//
//  UIView+Extension.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

extension UIView {
    /// xPos
    var x: CGFloat {
        get { return self.frame.origin.x }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// yPos
    var y: CGFloat {
        get { return self.frame.origin.y }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// 圆点
    var origin: CGPoint {
        get { return self.frame.origin }
        
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    /// 宽度
    var width: CGFloat {
        get { return self.frame.size.width }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// 高度
    var height: CGFloat {
        get { return self.frame.size.height }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// 大小
    var size: CGSize {
        get { return self.frame.size }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /// 左边
    var left: CGFloat {
        get { return self.frame.origin.x }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// 右边
    var right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    /// 上面
    var top: CGFloat {
        get { return self.frame.origin.y }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// 下面
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
}

