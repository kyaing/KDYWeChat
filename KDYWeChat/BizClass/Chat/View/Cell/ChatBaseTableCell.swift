//
//  ChatBaseTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

let kChatNicknameLabelHeight: CGFloat = 20  // 昵称 label 的高度
let kChatAvatarMarginLeft: CGFloat    = 10  // 头像的 margin left
let kChatAvatarMarginTop: CGFloat     = 0   // 头像的 margin top
let kChatAvatarWidth: CGFloat         = 40  // 头像的宽度

/// 聊天基类Cell
class ChatBaseTableCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.backgroundColor = UIColor.blueColor()
            avatarImageView.width = kChatAvatarWidth
            avatarImageView.height = kChatAvatarWidth
        }
    }
    
    // 用户名，用于群组聊天时
    @IBOutlet weak var nicknameLabel: UILabel! {
        didSet {
            nicknameLabel.font = UIFont.systemFontOfSize(12)
            nicknameLabel.textColor = UIColor.darkGrayColor()
        }
    }
    
    var model: ChatModel?
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setupCellContent(model: ChatModel) {
        self.model = model
        if model.fromMe {
            let avatarURL = "http://ww3.sinaimg.cn/thumbnail/6a011e49jw1f1e87gcr14j20ks0ksdgr.jpg"
            self.avatarImageView.kf_setImageWithURL(NSURL.init(string: avatarURL))
            
        } else {
            let avatarURL = "http://ww2.sinaimg.cn/large/6a011e49jw1f1j01nj8g6j204f04ft8r.jpg"
            self.avatarImageView.kf_setImageWithURL(NSURL.init(string: avatarURL))
        }
        
        self.setNeedsLayout()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }
        
        if model.fromMe {  // 自己发送的消息，在右边
            self.nicknameLabel.height = 0
            self.avatarImageView.left = UIScreen.width - kChatAvatarWidth - kChatAvatarMarginLeft
            
        } else {  // 接收别人的消息，在左边
            self.nicknameLabel.height = 0
            self.avatarImageView.left = kChatAvatarMarginLeft
        }
    }
}

