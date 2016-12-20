//
//  UIImage+Asset.swift
//  KDYWeChat
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation

typealias KDYAsset = UIImage.AssetIdentifier

extension UIImage {
    
    enum AssetIdentifier: String {
        
        // Tabbar
        case Tabbar_Chat_Normal     = "tabbar_mainframe"
        case Tabbar_Chat_Select     = "tabbar_mainframeHL"
        case Tabbar_Contacts_Normal = "tabbar_contacts"
        case Tabbar_Contacts_Select = "tabbar_contactsHL"
        case Tabbar_Discover_Normal = "tabbar_discover"
        case Tabbar_Discover_Select = "tabbar_discoverHL"
        case Tabbar_Me_Normal       = "tabbar_me"
        case Tabbar_Me_Select       = "tabbar_meHL"
        
        // Contacts
        
        // Discover 
        
        // Me

        var image: UIImage {
            return UIImage(assetIdentifier: self)
        }
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}

