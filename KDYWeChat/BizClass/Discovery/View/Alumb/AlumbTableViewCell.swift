//
//  AlumbTableViewCell.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/11/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import YYText

/// 朋友圈的Cell
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
        
        self.contentLabel = YYLabel()
        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = UIFont.systemFontOfSize(15)
        self.contentLabel.preferredMaxLayoutWidth = maxLayoutWidth
        self.contentLabel.backgroundColor = UIColor.clearColor()
        self.contentBodyView.addSubview(self.contentLabel)
        
        self.contentLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentBodyView)
        }
        
        self.contentBodyView.backgroundColor = UIColor.clearColor()
        self.pictureBodyView.backgroundColor = UIColor.clearColor()
        
        self.usernameLabel.textColor = UIColor(red: 73/255.0, green: 80/255.0, blue: 126/255.0, alpha: 1.0)
        self.timeLabel.textColor = UIColor.lightGrayColor()
    }
    
    /**
     *  设置Cell内容
     */
    func setupCellContents(model: AlumbModel) {
        self.avatarImage.kf_setImageWithURL(NSURL(string: model.avatarURL), placeholderImage: UIImage(named: kUserAvatarDefault))
    
        self.timeLabel.text     = model.time
        self.usernameLabel.text = model.nickname

        if let contentText = model.contentText {
            self.contentLabel.text = contentText
        }
    
        setupPicturesView(model.pictures)
    }
    
    /**
     *  创建照片墙 (根据照片个数布局)
     */
    func setupPicturesView(pictures: [String]?) {
        guard let counts = pictures?.count where pictures != nil else {
            self.pictureBodyHeight.constant = 0
            return
        }
    
        /// 单张图片宽度
        var pictureWidth: CGFloat  = 0
        /// 单张图片高度
        var pictureHeight: CGFloat = 0
        /// 图片之间的间隙
        let pictureGaps: CGFloat   = 5
        /// 照片墙最大宽度
        let pictureBodyViewWidth: CGFloat = 200
        /// 照片墙行数
        var pictureRows: Int = 0
        var pictureColumn: CGFloat = 0
        
        /**
         *  总共有五种情况：
         *  只有一张；两张以内；四张以内；六张以内；九张以内.
         */
        if counts == 1 {
            pictureRows = 1
            pictureColumn = 1
            
            pictureWidth  = 160
            pictureHeight = pictureWidth
            self.pictureBodyHeight.constant = pictureHeight
            
        } else if counts <= 2 {
            pictureRows = 1
            pictureColumn = 1
            
            pictureWidth  = (pictureBodyViewWidth - pictureGaps) / 2.0
            pictureHeight = pictureWidth
            self.pictureBodyHeight.constant = pictureHeight
            
        } else if counts <= 4 {
            pictureRows = 2
            pictureColumn = 2
            
            pictureWidth  = (pictureBodyViewWidth - pictureGaps) / 2.0
            pictureHeight = pictureWidth
            self.pictureBodyHeight.constant = pictureHeight * 2 + pictureGaps
            
        } else if counts <= 6 {
            pictureRows = 2
            pictureColumn = 3
            
            pictureWidth  = (pictureBodyViewWidth - pictureGaps * 2) / 3.0
            pictureHeight = pictureWidth
            self.pictureBodyHeight.constant = pictureHeight * 2 + pictureGaps
            
        } else if counts <= 9 {
            pictureRows = 3
            pictureColumn = 3
            
            pictureWidth  = (pictureBodyViewWidth - pictureGaps * 2) / 3.0
            pictureHeight = pictureWidth
            self.pictureBodyHeight.constant = pictureHeight * 2 + pictureGaps * 2
        }
        
        // 创建布局对应的照片
        var xPos: CGFloat = 0
        var yPos: CGFloat = 0
        
        for index in 0..<counts {
            // 创建相应的每张图片
            let imageView = UIImageView()
            imageView.frame = CGRect(x: xPos, y: yPos, width: pictureWidth, height: pictureHeight)
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 3
            self.pictureBodyView.addSubview(imageView)
            
            imageView.kf_setImageWithURL(NSURL(string: pictures![index]), placeholderImage: UIImage(named: kUserAvatarDefault))
            
            if ((index + 1) % pictureRows == 0) {
                xPos = 0
                yPos = yPos + pictureHeight + pictureGaps
            }
            else {
                xPos = xPos + pictureWidth + pictureGaps
            }
        }
    }
    
    /**
     *  计算Cell行高
     */
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

