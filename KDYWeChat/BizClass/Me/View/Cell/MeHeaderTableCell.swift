//
//  MeHeaderTableCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/16.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 我界面自定义Cell
class MeHeaderTableCell: UITableViewCell {
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var useridLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatorImageView.layer.cornerRadius = 5
        avatorImageView.layer.masksToBounds = true
        avatorImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        avatorImageView.layer.borderWidth = 0.5
        avatorImageView.contentMode = .ScaleAspectFit
    }
}

