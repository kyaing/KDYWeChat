//
//  MeHeaderTableCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/16.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

/// 我界面 Cell
class MeHeaderTableCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var useridLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatorImageView.layer.cornerRadius = 5
        self.avatorImageView.layer.masksToBounds = true
        self.avatorImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.avatorImageView.layer.borderWidth = 0.5
        self.avatorImageView.contentMode = .scaleAspectFill
    }
}

