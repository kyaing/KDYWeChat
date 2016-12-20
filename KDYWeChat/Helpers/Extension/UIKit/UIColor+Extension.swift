//
//  UIColor+Extension.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

typealias KDYColor = UIColor.AppColorName

extension UIColor {
    
    enum AppColorName: String {
        case ChatGreen           = "#09BB07"
        case ChatLightGreen      = "#A8E980"
        case BarTint             = "#1A1A1A"
        case TabbarSelectedText  = "#68BB1E"
        case TableBackground     = "#f5f5f5"
        case Separator           = "#C8C8C8"
        case NetworkFailed       = "#FFC8C8"
        
        case RecordBgNormal      = "#F3F4F8"
        case RecordBgSelect      = "#C6C7CB"
        
        var color: UIColor {
            return UIColor(colorHex: self.rawValue)!
        }
    }
    
    convenience init?(colorHex: String, alpha: CGFloat = 1.0) {
        var formatted = colorHex.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        
        if let hex = Int(formatted, radix: 16) {
            let red   = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue  = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
            
        } else {
            return nil
        }
    }
}

