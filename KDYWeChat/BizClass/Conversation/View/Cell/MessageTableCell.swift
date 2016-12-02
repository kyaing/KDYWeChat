//
//  MessageTableCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/11.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

class MessageTableCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var unReadMsgLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMsgDateLabel: UILabel!
    
    @IBOutlet weak var unReadMsgWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var unReadMsgHeightContriant: NSLayoutConstraint!
    
    var model: MessageModel! {
        willSet {
            userNameLabel.text     = newValue.title
            lastMessageLabel?.text = newValue.lastContent
            lastMsgDateLabel.text  = newValue.lastTime
            unReadMsgLabel.text    = newValue.unReadCount
            
            let unReadCount = newValue.unReadCount.toInt()
            guard unReadCount > 0 else {  return unReadMsgLabel.hidden = true }
            
            unReadMsgLabel.hidden = false
            unReadMsgLabel.text = newValue.unReadCount
            
            // 处理气泡的大小
            if unReadCount > 9 {
                unReadMsgWidthContraint.constant  = 23
                unReadMsgHeightContriant.constant = 18
                unReadMsgLabel.layer.cornerRadius = 9
                
                if unReadCount > 99 {
                    unReadMsgLabel.text = "99"
                }
                
            } else {
                unReadMsgWidthContraint.constant  = 19
                unReadMsgHeightContriant.constant = 19
                unReadMsgLabel.layer.cornerRadius = 9.5
            }
            
            // 处理头像
            if let userInfo = UserInfoManager.shareInstance.getUserInfoByName(newValue.conversation.conversationId) where userInfo.imageUrl != nil {
                    avatorImageView.kf_setImageWithURL(NSURL(string: userInfo.imageUrl!), placeholderImage: UIImage(named: kUserAvatarDefault), optionsInfo: nil)
            } else {
                avatorImageView.image = UIImage(named: kUserAvatarDefault)
            }
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatorImageView.layer.cornerRadius  = 5
        avatorImageView.layer.masksToBounds = true
        avatorImageView.contentMode = .ScaleAspectFill

        unReadMsgLabel.layer.cornerRadius   = 9.5
        unReadMsgLabel.layer.masksToBounds  = true
        
        lastMessageLabel.textColor = UIColor.grayColor()
        lastMsgDateLabel.textColor = UIColor.grayColor()
    }
    
    // 当Cell选中和高高时，重新设置label颜色
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        unReadMsgLabel.backgroundColor = .redColor()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        unReadMsgLabel.backgroundColor = .redColor()
    }
}

