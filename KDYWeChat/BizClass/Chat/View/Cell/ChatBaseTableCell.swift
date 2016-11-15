//
//  ChatBaseTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

let kChatNicknameLabelHeight: CGFloat = 20  // 昵称 label 的高度
let kChatAvatarMarginLeft: CGFloat    = 10  // 头像的 margin left
let kChatAvatarMarginTop: CGFloat     = 0   // 头像的 margin top
let kChatAvatarWidth: CGFloat         = 40  // 头像的宽度

/// 聊天基类Cell
class ChatBaseTableCell: UITableViewCell {

    // 聊天头像
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.backgroundColor = UIColor.blueColor()
            avatarImageView.width = kChatAvatarWidth
            avatarImageView.height = kChatAvatarWidth
            avatarImageView.contentMode = .ScaleAspectFill
            avatarImageView.layer.masksToBounds = true
        }
    }
    
    // 用户名，用于群组聊天时
    @IBOutlet weak var nicknameLabel: UILabel! {
        didSet {
            nicknameLabel.font = UIFont.systemFontOfSize(12)
            nicknameLabel.textColor = UIColor.darkGrayColor()
        }
    }
    
    // 菊花进度控件
    lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.contentView.addSubview(activityView)
        
        return activityView
    }()
    
    // 消息发送失败按钮
    lazy var failSendMsgButton: UIButton = {
        let failButton = UIButton()
        failButton.size = CGSizeMake(20, 20)
        failButton.setImage(UIImage(named: "messageSendFail"), forState: .Normal)
        failButton.addTarget(self, action: #selector(self.reSendMessageAction), forControlEvents: .TouchUpInside)
        
        self.contentView.addSubview(failButton)
        
        return failButton
    }()
    
    weak var cellDelegate: ChatCellActionDelegate?
    
    var model: ChatModel?
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        
        let tapAvatarGuesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAvatarAction))
        self.avatarImageView.userInteractionEnabled = true
        self.avatarImageView.addGestureRecognizer(tapAvatarGuesture)
    }
    
    func setupCellContent(model: ChatModel) {
        self.model = model
        
        let currentUser = UserInfoManager.shareInstance.getCurrentUserInfo()
        if model.fromMe! {   // 发送方
            if let imageURL = currentUser?.imageUrl {
                self.avatarImageView.kf_setImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: kUserAvatarDefault), optionsInfo: nil)
            } else {
                self.avatarImageView.image = UIImage(named: kUserAvatarDefault)
            }
            
        } else {   // 接收方
            if let imageURL = model.avatarURL {
                self.avatarImageView.kf_setImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: kUserAvatarDefault), optionsInfo: nil)
            } else {
                self.avatarImageView.image = UIImage(named: kUserAvatarDefault)
            }
        }
        
        // 判断消息发送的状态 (发送中/成功/失败)
        if model.fromMe! {
            switch model.messageStatus {
            case EMMessageStatusPending, EMMessageStatusDelivering:
                print("消息正在发送中...")
                self.failSendMsgButton.hidden = true
                
                self.activityView.hidden = false
                self.activityView.startAnimating()
                
            case EMMessageStatusSuccessed:
                print("消息发送成功")
                self.failSendMsgButton.hidden = true
                
                self.activityView.stopAnimating()
                self.activityView.hidden = true
                
            case EMMessageStatusFailed:
                print("消失发送失败")
                self.failSendMsgButton.hidden = false
                self.activityView.hidden = true
                
            default:
                break
            }
        }
        
        self.setNeedsLayout()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }
        
        if model.fromMe! {  // 发送方，在右边
            self.nicknameLabel.height = 0
            self.avatarImageView.left = UIScreen.width - kChatAvatarWidth - kChatAvatarMarginLeft
            
        } else {  // 接收方，在左边
            self.nicknameLabel.height = 0
            self.avatarImageView.left = kChatAvatarMarginLeft
        }
    }
    
    // MARK: - Event Response
    /**
     *  点击头像
     */
    func tapAvatarAction() {
        guard let delegate = self.cellDelegate else { return }
        delegate.didClickCellAavator(self)
    }
    
    /**
     *  重新发送消息
     */
    func reSendMessageAction() {
        
    }
}

