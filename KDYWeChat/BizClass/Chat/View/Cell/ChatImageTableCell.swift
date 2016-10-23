//
//  ChatImageTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Kingfisher

let kChatImageMinWidth: CGFloat  = 120  // 最小的图片宽度
let kChatImageMaxWidth: CGFloat  = 150  // 最大的图片宽度
let kChatImageMinHeight: CGFloat = 120  // 最小的图片高度
let kChatImageMaxHeight: CGFloat = 170  // 最大的图片高度

/// 聊天图片Cell
class ChatImageTableCell: ChatBaseTableCell {
    
    @IBOutlet weak var chatImageView: UIImageView!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 这里不能使用 .ScaleAspectFit模式
        self.chatImageView.contentMode = .ScaleAspectFill
    }
    
    override func setupCellContent(model: ChatModel) {
        super.setupCellContent(model)
        
        if let thumbnailImage = model.thumbnailImage {
            self.chatImageView.kf_setImageWithURL(NSURL(string: model.fileURLPath!), placeholderImage: thumbnailImage)
        }
        
        self.setNeedsLayout()
    }
    
    // MARK: - Private Methods
    /**
     获取缩略图的尺寸
     
     - parameter originalSize: 原始图的尺寸 size
     - returns: 返回的缩略图尺寸
     */
    class func getThumbImageSize(originalSize: CGSize) -> CGSize {
        
        let imageRealHeight = originalSize.height
        let imageRealWidth  = originalSize.width
        
        var resizeThumbWidth: CGFloat
        var resizeThumbHeight: CGFloat
        
        /**
         *  1）如果图片的高度 >= 图片的宽度 , 高度就是最大的高度，宽度等比
         *  2）如果图片的高度 < 图片的宽度 , 以宽度来做等比，算出高度
         */
        if imageRealHeight >= imageRealWidth {
            let scaleWidth = imageRealWidth * kChatImageMaxHeight / imageRealHeight
            resizeThumbWidth = (scaleWidth > kChatImageMinWidth) ? scaleWidth : kChatImageMinWidth
            resizeThumbHeight = kChatImageMaxHeight
            
        } else {
            let scaleHeight = imageRealHeight * kChatImageMaxWidth / imageRealWidth
            resizeThumbHeight = (scaleHeight > kChatImageMinHeight) ? scaleHeight : kChatImageMinHeight
            resizeThumbWidth = kChatImageMaxWidth
        }
        
        return CGSizeMake(resizeThumbWidth, resizeThumbHeight)
    }
    
    func CGRectCenterRectForResizableImage(image: UIImage) -> CGRect {
        return CGRectMake(
            image.capInsets.left / image.size.width,
            image.capInsets.top / image.size.height,
            (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
            (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height
        )
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }
        
        let imageOriginalWidth  = model.thumbnailImageSize.width
        let imageOriginalHeight = model.thumbnailImageSize.height
        
        // 根据原图尺寸等比获取缩略图的 size
        let originalSize = CGSizeMake(imageOriginalWidth, imageOriginalHeight)
        self.chatImageView.size = ChatImageTableCell.getThumbImageSize(originalSize)
        
        if model.fromMe! {
            // value = 屏幕宽 - 头像的边距10 - 头像宽 - 气泡距离头像的 gap 值 - 图片宽
            self.chatImageView.left = UIScreen.width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft - self.chatImageView.width
        } else {
            // value = 距离屏幕左边的距离
            self.chatImageView.left = kChatBubbleLeft
        }
        
        self.chatImageView.top = self.avatarImageView.top
        
        // 拉伸图片
        let stretchImage = (model.fromMe!) ? UIImage(named: "SenderTextNodeBkg") : UIImage(named: "ReceiverTextNodeBkg")
        let bubbleMaskImage = stretchImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(30, 10, 23, 28), resizingMode: .Stretch)
        
        // 设置image的 mask图层
        let maskLayer = CALayer()
        maskLayer.contents = bubbleMaskImage.CGImage
        maskLayer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage)
        maskLayer.contentsScale = UIScreen.mainScreen().scale
        maskLayer.opacity = 1
        maskLayer.frame = CGRectMake(0, 0, self.chatImageView.width, self.chatImageView.height)
        
        self.chatImageView.layer.mask = maskLayer
        self.chatImageView.layer.masksToBounds = true
    }
    
    class func layoutHeight(model: ChatModel) -> CGFloat {        
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        
        var height = kChatAvatarMarginTop + kChatBubblePaddingBottom
        
        let imageOriginalWidth  = model.thumbnailImageSize.width
        let imageOriginalHeight = model.thumbnailImageSize.height
        
        /**
         *  1）如果图片的高度 >= 图片的宽度 , 高度就是最大的高度，宽度等比
         *  2）如果图片的高度 < 图片的宽度 , 以宽度来做等比，算出高度
         */
        if imageOriginalHeight >= imageOriginalWidth {
            height += kChatImageMaxHeight
            
        } else {
            let scaleHeight = imageOriginalHeight * kChatImageMaxWidth / imageOriginalWidth
            height += (scaleHeight > kChatImageMinHeight) ? scaleHeight : kChatImageMinHeight
        }
        
        height += 5  // 图片距离底部的距离
        model.cellHeight = height
        
        return model.cellHeight
    }
}

