//
//  ChatImageTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Kingfisher
import Reusable

let kChatImageMinWidth: CGFloat  = 120  // 最小的图片宽度
let kChatImageMaxWidth: CGFloat  = 150  // 最大的图片宽度
let kChatImageMinHeight: CGFloat = 120  // 最小的图片高度
let kChatImageMaxHeight: CGFloat = 150  // 最大的图片高度

/// 聊天图片Cell
class ChatImageTableCell: ChatBaseTableCell, NibReusable {
    
    @IBOutlet weak var chatImageView: UIImageView!
    
    /// 用于图片下载
    lazy var imageIndicatiorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.contentView.addSubview(activityView)
        
        return activityView
    }()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 这里不能使用 .ScaleAspectFit模式
        self.chatImageView.contentMode = .scaleAspectFill
    }
    
    override func setupCellContent(_ model: ChatModel) {
        super.setupCellContent(model)
        
        if !model.fromMe {   // 接收方
            if let thumbnailImage = model.thumbnailImage {
                chatImageView.kf.setImage(with: URL(string: model.fileURLPath!), placeholder: thumbnailImage)
                
            } else {
                chatImageView.kf.setImage(with: URL(string: model.fileURLPath!), placeholder: KDYAsset.AvatarDefault.image)
            }
            
        } else {   // 发送方
            if let thumbnailImage = model.thumbnailImage {
                self.chatImageView.image = thumbnailImage
            }
        }
        
        self.setNeedsLayout()
    }
    
    // MARK: - Private Methods
    /**
     获取缩略图的尺寸
     
     - parameter originalSize: 原始图的尺寸 size
     - returns: 返回的缩略图尺寸
     */
    class func getThumbImageSize(_ originalSize: CGSize) -> CGSize {
        
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
        
        return CGSize(width: resizeThumbWidth, height: resizeThumbHeight)
    }
    
    func CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect {
        return CGRect(
            x: image.capInsets.left / image.size.width,
            y: image.capInsets.top / image.size.height,
            width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
            height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height
        )
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }
        
        var imageOriginalWidth  = kChatImageMinWidth
        var imageOriginalHeight = kChatImageMinHeight
        
        if model.thumbnailImage != nil {
            imageOriginalWidth  = model.thumbnailImageSize.width
            imageOriginalHeight = model.thumbnailImageSize.height
            
        } else {
            imageOriginalWidth  = model.imageSize.width
            imageOriginalHeight = model.imageSize.height
        }
        
        // 根据原图尺寸等比获取缩略图的 size
        let originalSize = CGSize(width: imageOriginalWidth, height: imageOriginalHeight)
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
        let stretchImage = (model.fromMe!) ? KDYAsset.Chat_SenderBg_Normal.image : KDYAsset.Chat_ReceiverBg_Normal.image
        let bubbleMaskImage = stretchImage.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 10, 23, 28), resizingMode: .stretch)
        
        // 设置image的 mask图层
        let maskLayer = CALayer()
        maskLayer.contents = bubbleMaskImage.cgImage
        maskLayer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage)
        maskLayer.contentsScale = UIScreen.main.scale
        maskLayer.opacity = 1
        maskLayer.frame = CGRect(x: 0, y: 0, width: self.chatImageView.width, height: self.chatImageView.height)
        
        self.chatImageView.layer.mask = maskLayer
        self.chatImageView.layer.masksToBounds = true
        
        // 发送方
        if model.fromMe! {
            // 图片消息，发送消息的进度菊花布局
            self.activityView.left = self.chatImageView.left - 20
            self.activityView.top  = self.chatImageView.top + self.chatImageView.height / 2.0 - 15
            
            // 消息发送失败按钮
            self.failSendMsgButton.left = self.activityView.left
            self.failSendMsgButton.top  = self.activityView.top
        }
    }
    
    class func layoutHeight(_ model: ChatModel) -> CGFloat {        
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        
        var height = kChatAvatarMarginTop + kChatBubblePaddingBottom
        
        var imageOriginalWidth  = kChatImageMinWidth
        var imageOriginalHeight = kChatImageMinHeight
        
        if model.thumbnailImage != nil {
            imageOriginalWidth  = model.thumbnailImageSize.width
            imageOriginalHeight = model.thumbnailImageSize.height
            
        } else {
            imageOriginalWidth  = model.imageSize.width
            imageOriginalHeight = model.imageSize.height
        }
        
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

