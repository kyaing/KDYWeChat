//
//  ChatTimeTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 聊天时间Cell
class ChatTimeTableCell: UITableViewCell {
    
    // 时间标签
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.layer.cornerRadius = 6
            timeLabel.layer.masksToBounds = true
            timeLabel.textColor = UIColor.whiteColor()
            timeLabel.backgroundColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 0.5)
        }
    }
    
    var model: ChatModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
    }
    
    func setupCellContent(model: ChatModel) {
        self.model = model
        self.timeLabel.text = model.timestamp
    }
}

