//
//  MessageTableCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/11.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
            guard unReadCount > 0 else {  return unReadMsgLabel.isHidden = true }
            
            unReadMsgLabel.isHidden = false
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
            if let userInfo = UserInfoManager.shareInstance.getUserInfoByName(newValue.conversation.conversationId) , userInfo.imageUrl != nil {
                    avatorImageView.kf_setImageWithURL(URL(string: userInfo.imageUrl!), placeholderImage: UIImage(named: kUserAvatarDefault), optionsInfo: nil)
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
        avatorImageView.contentMode = .scaleAspectFill

        unReadMsgLabel.layer.cornerRadius   = 9.5
        unReadMsgLabel.layer.masksToBounds  = true
        
        lastMessageLabel.textColor = UIColor.gray
        lastMsgDateLabel.textColor = UIColor.gray
    }
    
    // 当Cell选中和高高时，重新设置label颜色
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        unReadMsgLabel.backgroundColor = .red()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        unReadMsgLabel.backgroundColor = .red()
    }
}

