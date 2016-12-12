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
        case chatGreenColor           = "#09BB07"
        case chatLightGreenColor      = "#A8E980"
        case barTintColor             = "#1A1A1A"
        case tabbarSelectedTextColor  = "#68BB1E"
        case navigationItemTextColor  = ""
        case tableViewBackgroundColor = "#f5f5f5"
        case separatorColor           = "#C8C8C8"
        case networkFailedColor       = "#FFC8C8"
    }
    
    public convenience init?(colorHex: String, alpha: CGFloat = 1.0) {
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

