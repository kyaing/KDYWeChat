//
//  ChatTimeTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

/// 聊天时间Cell
class ChatTimeTableCell: UITableViewCell, NibReusable {
    
    // 时间标签
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.layer.cornerRadius = 6
            timeLabel.layer.masksToBounds = true
            timeLabel.textColor = UIColor.white
            timeLabel.backgroundColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 0.5)
        }
    }
    
    var model: ChatModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    func setupCellContent(_ model: ChatModel) {
        self.model = model
        self.timeLabel.text = model.timestamp
    }
}

