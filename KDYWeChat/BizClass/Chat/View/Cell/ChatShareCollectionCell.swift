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
        self.shareButton.imageView?.contentMode = .ScaleAspectFit
    }
}

