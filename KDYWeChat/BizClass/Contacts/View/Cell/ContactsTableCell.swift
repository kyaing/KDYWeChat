//
//  ContactsTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

/// 联系人Cell
class ContactsTableCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var avatorImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatorImage.layer.masksToBounds = true
        self.avatorImage.contentMode = .scaleAspectFill
    }
}

