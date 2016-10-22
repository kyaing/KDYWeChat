//
//  MessageTableCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/11.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var unReadMsgLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMsgDateLabel: UILabel!
    
    var newModel: MessageModel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatorImageView.layer.cornerRadius  = 5
        avatorImageView.layer.masksToBounds = true

        unReadMsgLabel.layer.cornerRadius   = 10
        unReadMsgLabel.layer.masksToBounds  = true
        
        lastMessageLabel.textColor = UIColor.grayColor()
        lastMsgDateLabel.textColor = UIColor.grayColor()
    }
    
    // 当cell选中和高高时，重新设置label颜色
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        unReadMsgLabel.backgroundColor = .redColor()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        unReadMsgLabel.backgroundColor = .redColor()
    }
}

