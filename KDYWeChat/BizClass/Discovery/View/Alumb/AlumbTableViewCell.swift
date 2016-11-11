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
    /// 文本内容视图
    @IBOutlet weak var contentBodyView: UIView!
    /// 图片内容视图
    @IBOutlet weak var pictureBodyView: UIView!
    /// 图片视图高度约束
    @IBOutlet weak var pictureBodyHeight: NSLayoutConstraint!
    /// 文本内容
    var contentLabel: YYLabel!
    /// 文本布局最大宽度：屏宽 - 距左约束 - 距右约束
    let maxLayoutWidth = UIScreen.width - 65 - 20
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.pictureBodyHeight.constant = 80
        
        self.contentLabel = YYLabel()
        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = UIFont.systemFontOfSize(15)
        self.contentLabel.preferredMaxLayoutWidth = maxLayoutWidth
        self.contentLabel.backgroundColor = UIColor.clearColor()
        self.contentBodyView.addSubview(self.contentLabel)
        self.contentBodyView.backgroundColor = UIColor.clearColor()
        
        self.contentLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentBodyView)
        }
        
        self.usernameLabel.textColor = UIColor(red: 73/255.0, green: 80/255.0, blue: 126/255.0, alpha: 1.0)
        self.timeLabel.textColor = UIColor.lightGrayColor()
    }
    
    func setupCellContents(model: AlumbModel) {
        self.avatarImage.kf_setImageWithURL(NSURL(string: model.avatarURL), placeholderImage: UIImage(named: kUserAvatarDefault))
        self.contentLabel.text = model.contentText
        self.timeLabel.text = model.time
        self.usernameLabel.text = model.nickname
    }
    
    func getCellHeight() -> CGFloat {
        layoutSubviews()
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
        layoutIfNeeded()
        
        // 若用了系统的分隔线，就再加1个像素，否则高度出错
        let cellHiehgt = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        
        return cellHiehgt + 1
    }
}

