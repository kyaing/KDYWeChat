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
    
    convenience init(colorHex name: AppColorName) {
        self.init(rgba: name.rawValue)
    }
}

