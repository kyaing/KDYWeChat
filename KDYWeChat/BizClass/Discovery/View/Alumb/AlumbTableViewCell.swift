//
//  AlumbTableViewCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/11/8.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import SnapKit

/// 朋友圈Cell
class AlumbTableViewCell: UITableViewCell {
    
    /// 头像
    var avatorImage: UIImageView!
    /// 昵称
    var username: UILabel!
    /// 正文视图
    var bodyView: UIView!
    /// 时间
    var timeLabel: UILabel!
    /// 评论按钮
    var commentBtn: UIButton!
    /// 评论视图
    var commentView: UIView!
    
    // MARK: - Life Cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAllViews()
        setupAllConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Methods
    func setupAllViews() {
        // 头像
        self.avatorImage = UIImageView()
        self.avatorImage.userInteractionEnabled = true
        self.avatorImage.image = UIImage(named: kUserAvatarDefault)
        self.contentView.addSubview(self.avatorImage)
        
        // 昵称
        self.username = UILabel()
        self.username.textColor = UIColor.darkGrayColor()
        self.username.textAlignment = .Left
        self.username.font = UIFont.systemFontOfSize(16)
        self.username.text = "kaideyi"
        self.contentView.addSubview(self.username)
        
        // 正文视图
        self.bodyView = UIView()
        self.bodyView.backgroundColor = UIColor.redColor()
        self.contentView.addSubview(self.bodyView)
        
        // 时间 
        self.timeLabel = UILabel()
        self.timeLabel.text = "2016-11-9"
        self.timeLabel.font = UIFont.systemFontOfSize(12)
        self.contentView.addSubview(self.timeLabel)
        
        // 评论视图
        self.commentView = UIView()
        self.contentView.addSubview(self.commentView)
    }
    
    func setupAllConstraints() {
        // 头像
        self.avatorImage.snp_makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).inset(UIEdgeInsetsMake(15, 15, 0, 0))
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        // 昵称
        self.username.snp_makeConstraints { (make) in
            make.top.equalTo(self.avatorImage)
            make.left.equalTo(self.avatorImage.snp_right).offset(10)
            make.right.equalTo(self.contentView.snp_right).offset(-15)
            make.height.equalTo(25)
        }
        
        // 正文视图
        self.bodyView.snp_makeConstraints { (make) in
            make.top.equalTo(self.username.snp_bottom).offset(10)
            make.left.equalTo(self.username.snp_left)
            make.right.equalTo(self.contentView.snp_right).offset(-15)
            make.height.equalTo(100)
        }
        
        // 时间
        self.timeLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.bodyView.snp_bottom).offset(10)
            make.left.equalTo(self.username.snp_left)
            make.right.equalTo(self.contentView.snp_right).offset(-15)
            make.height.equalTo(15)
        }
        
        // 评论视图
        self.commentView.snp_makeConstraints { (make) in
            
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

