//
//  UIView+Extension.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

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
    
    /// origin
    var origin: CGPoint {
        get { return self.frame.origin }
        
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    /// width
    var width: CGFloat {
        get { return self.frame.size.width }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// height
    var height: CGFloat {
        get { return self.frame.size.height }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// size
    var size: CGSize {
        get { return self.frame.size }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /// left
    var left: CGFloat {
        get { return self.frame.origin.x }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// right
    var right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    /// top
    var top: CGFloat {
        get { return self.frame.origin.y }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// bottom
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    /**
     *  移除所有子视图
     */
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}

