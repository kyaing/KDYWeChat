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
    
    var avatorImage: UIImageView!
    var username: UILabel!
    var context: UITextView!
    var picture: UIImageView?
    var comment: UIView?
    
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
        
        // 昵称
        
        // 正文
        
        // 图片
        
        // 评论
    }
    
    func setupAllConstraints() {
        
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

