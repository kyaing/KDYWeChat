//
//  AlumbHeaderView.swift
//  KDYWeChat
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

/// 朋友圈头部视图
class AlumbHeaderView: UIView, NibReusable {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var avatorView: UIView!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatorView.layer.borderColor = UIColor.darkGray.cgColor
        self.avatorView.layer.borderWidth = 0.5
        
        if let currentUser = UserInfoManager.shareInstance.getCurrentUserInfo() {
            if let imageURL = currentUser.imageUrl {
                self.avatorImageView.kf_setImageWithURL(URL(string: imageURL), placeholderImage: UIImage(named: kUserAvatarDefault), optionsInfo: nil)
            }
            
            self.usernameLabel.text = currentUser.username
        }
    }
}

