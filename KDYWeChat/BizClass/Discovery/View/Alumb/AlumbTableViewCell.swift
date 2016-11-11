//
//  AlumbTableViewCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/11/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import YYText

/// 朋友圈Cell
class AlumbTableViewCell: UITableViewCell {

    /// 头像
    @IBOutlet weak var avatarImage: UIImageView!
    /// 用户名
    @IBOutlet weak var usernameLabel: UILabel!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 文本内容
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 文本布局最大宽度：屏宽 - 距左约束 - 距右约束
    let maxLayoutWidth = UIScreen.width - 65 - 20
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.contentLabel.preferredMaxLayoutWidth = maxLayoutWidth
        self.contentLabel.backgroundColor = UIColor.clearColor()
        
        self.usernameLabel.textColor = UIColor(red: 150/255.0, green: 180/255.0, blue: 230/255.0, alpha: 1.0)
        self.timeLabel.textColor = UIColor.lightGrayColor()
    }
    
    func setupCellContents(model: AlumbModel) {
        self.avatarImage.kf_setImageWithURL(NSURL(string: model.avatarURL), placeholderImage: UIImage(named: kUserAvatarDefault))
        self.contentLabel.text = model.contentText
        self.timeLabel.text = model.time
        self.usernameLabel.text = model.nickname
    }
    
    func getCellHeight() -> CGFloat {
        // 若用了系统的分隔线，就再加1个像素，否则高度出错
        let cellHiehgt = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        return cellHiehgt + 1
    }
}

