//
//  ChatTextTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import YYText

/// 下面这手算布局，能用SnapKit计算吗？
let kChatTextLeft: CGFloat = 72                                         //消息在左边的时候， 文字距离屏幕左边的距离
let kChatTextMaxWidth: CGFloat = UIScreen.width - kChatTextLeft - 82    //消息在右边， 70：文本离屏幕左的距离，  82：文本离屏幕右的距离
let kChatTextMarginTop: CGFloat = 12                                    //文字的顶部和气泡顶部相差 12 像素
let kChatTextMarginBottom: CGFloat = 11                                 //文字的底部和气泡底部相差 11 像素
let kChatTextMarginLeft: CGFloat = 17                                   //文字的左边 和气泡的左边相差 17 ,包括剪头部门
let kChatBubbleWidthBuffer: CGFloat = kChatTextMarginLeft*2             //气泡比文字的宽度多出的值
let kChatBubbleBottomTransparentHeight: CGFloat = 11                    //气泡底部的透明高度 11
let kChatBubbleHeightBuffer: CGFloat = kChatTextMarginTop + kChatTextMarginBottom  //文字的顶部 + 文字底部距离
let kChatBubbleImageViewHeight: CGFloat = 54                            //气泡最小高 54 ，防止拉伸图片变形
let kChatBubbleImageViewWidth: CGFloat = 50                             //气泡最小宽 50 ，防止拉伸图片变形
let kChatBubblePaddingTop: CGFloat = 3                                  //气泡顶端有大约 3 像素的透明部分，需要和头像持平
let kChatBubbleMaginLeft: CGFloat = 5                                   //气泡和头像的 gap 值：5
let kChatBubblePaddingBottom: CGFloat = 8                               //气泡距离底部分割线 gap 值：8
let kChatBubbleLeft: CGFloat = kChatAvatarMarginLeft + kChatAvatarWidth + kChatBubbleMaginLeft  //气泡距离屏幕左的距
private let kChatTextFont: UIFont = UIFont.systemFontOfSize(16)

/// 聊天文本Cell
class ChatTextTableCell: ChatBaseTableCell {

    // 聊天背景图片
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    // 内容文本 (使用YYText处理)
    @IBOutlet weak var contentLabel: YYLabel! {
        didSet {
            contentLabel.backgroundColor = UIColor.clearColor()
            contentLabel.numberOfLines = 0
            contentLabel.displaysAsynchronously = false
            contentLabel.ignoreCommonProperties = true
            contentLabel.textVerticalAlignment = .Top
            contentLabel.font = kChatTextFont
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // 设置文本内容
    override func setupCellContent(model: ChatModel) {
        super.setupCellContent(model)
        
        if let textLinePositionModifier = model.textLinePositionModifier {
            self.contentLabel.linePositionModifier = textLinePositionModifier
        }
        
        if let textLayout = model.textLayout {
            self.contentLabel.textLayout = textLayout
        }
        
        if let textAttributedString = model.textAttributedString {
            self.contentLabel.attributedText = textAttributedString
        }
        
        // 拉伸气泡图片
        let stretchImage = model.fromMe ? UIImage(named: "SenderTextNodeBkg") : UIImage(named: "ReceiverTextNodeBkg")
        let bubbleImage = stretchImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .Stretch)
        self.bubbleImageView.image = bubbleImage
        
        self.setNeedsLayout()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }

        self.contentLabel.size = model.textLayout!.textBoundingSize
        if model.fromMe {
            // value = 屏幕宽 - 头像的边距10 - 头像宽 - 气泡距离头像的 gap 值 - (文字宽 - 2倍的文字和气泡的左右距离 , 或者是最小的气泡图片距离)
            self.bubbleImageView.left = UIScreen.width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft - max(self.contentLabel.width + kChatBubbleWidthBuffer, kChatBubbleImageViewWidth)
            
        } else {
            // value = 距离屏幕左边的距离
            self.bubbleImageView.left = kChatBubbleLeft
        }
        
        // 设置气泡的宽
        self.bubbleImageView.width = max(self.contentLabel.width + kChatBubbleWidthBuffer, kChatBubbleImageViewWidth)
        
        // 设置气泡的高度
        self.bubbleImageView.height = max(self.contentLabel.height + kChatBubbleHeightBuffer + kChatBubbleBottomTransparentHeight, kChatBubbleImageViewHeight)
        
        // value = 头像的底部 - 气泡透明间隔值
        self.bubbleImageView.top = self.nicknameLabel.bottom - kChatBubblePaddingTop
        
        // value = 气泡顶部 + 文字和气泡的差值
        self.contentLabel.top = self.bubbleImageView.top + kChatTextMarginTop
        
        // value = 气泡左边 + 文字和气泡的差值
        self.contentLabel.left = self.bubbleImageView.left + kChatTextMarginLeft
    }
    
    /**
     *  根据数据模型，计算高度
     */
    class func layoutCellHeight(model: ChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        
        // 解析富文本
        let attributedString: NSMutableAttributedString = TSChatTextParser.parseText(model.messageContent!, font: kChatTextFont)!
        model.textAttributedString = attributedString
        
        // 初始化排版布局对象
        let modifier = TSYYTextLinePositionModifier(font: kChatTextFont)
        model.textLinePositionModifier = modifier
        
        // 初始化 YYTextContainer
        let textContainer: YYTextContainer = YYTextContainer()
        textContainer.size = CGSize(width: kChatTextMaxWidth, height: CGFloat.max)
        textContainer.linePositionModifier = modifier
        textContainer.maximumNumberOfRows = 0
        
        // 设置 layout
        let textLayout = YYTextLayout(container: textContainer, text: attributedString)
        model.textLayout = textLayout
        
        // 计算高度
        var height: CGFloat = kChatAvatarMarginTop + kChatBubblePaddingBottom
        let stringHeight = modifier.heightForLineCount(Int(textLayout!.rowCount))
        
        height += max(stringHeight + kChatBubbleHeightBuffer + kChatBubbleBottomTransparentHeight, kChatBubbleImageViewHeight)
        model.cellHeight = height
        
        return model.cellHeight
    }
}

