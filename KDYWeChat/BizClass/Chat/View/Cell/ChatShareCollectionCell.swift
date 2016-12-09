//
//  ChatShareCollectionCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 聊天扩展视图Cell
class ChatShareCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.shareButton.isUserInteractionEnabled = false
        self.shareButton.layer.cornerRadius = 10
        self.shareButton.layer.masksToBounds = true
        self.shareButton.layer.borderWidth = 0.5
        self.shareButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func shareButtonAction(_ sender: AnyObject) {
       
    }
}

