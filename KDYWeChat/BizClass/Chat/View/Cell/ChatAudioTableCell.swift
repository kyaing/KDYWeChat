//
//  ChatAudioTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

private let kAudioMaxWidth: CGFloat = 200
private let kAudioMinWidth: CGFloat = 70

private let kChatVoicePlayingMarginLeft: CGFloat = 16  // 播放小图标距离气泡箭头的值

/// 聊天语音Cell
class ChatAudioTableCell: ChatBaseTableCell, NibReusable {

    /// 播放语音按钮
    @IBOutlet weak var voiceButton: UIButton! {
        didSet {
            voiceButton.backgroundColor = UIColor.clear
        }
    }
    
    /// 语音时长标签
    @IBOutlet weak var vocieTimeLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupCellContent(_ model: ChatModel) {
        super.setupCellContent(model)
    
        // 拉伸气泡图片，设置语音按钮背景图片
        let stretchImage = (model.fromMe!) ? KDYAsset.Chat_SenderBg_Normal.image : KDYAsset.Chat_ReceiverBg_Normal.image
        let bubbleImage = stretchImage.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .stretch)
        
        // 设置语音按钮高亮时的背景图片
        let stretchHLImage = (model.fromMe!) ? KDYAsset.Chat_SenderBg_Select.image: KDYAsset.Chat_ReceiverBg_Select.image
        let bubbleHLImage  = stretchHLImage.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .stretch)
        
        self.voiceButton.setBackgroundImage(bubbleImage, for: UIControlState())
        self.voiceButton.setBackgroundImage(bubbleHLImage, for: .highlighted)
        
        // 设置语音按钮播放图片
        let voiceImage = (model.fromMe!) ? KDYAsset.Chat_Sender_Playing.image : KDYAsset.Chat_Receiver_Playing.image
        self.voiceButton.setImage(voiceImage, for: UIControlState())
        
        // 设置语音按钮，图片的内边距与对齐方式
        self.voiceButton.imageEdgeInsets = (model.fromMe!) ? UIEdgeInsetsMake(-kChatBubbleBottomTransparentHeight, 0, 0, kChatVoicePlayingMarginLeft) : UIEdgeInsetsMake(-kChatBubbleBottomTransparentHeight, kChatVoicePlayingMarginLeft, 0, 0)
        self.voiceButton.contentHorizontalAlignment = (model.fromMe!) ? .right : .left

        // 语音总时长
        self.vocieTimeLabel.text = String(format:"%zd\"", Int(model.duration))
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }
        
        // 根据时长，计算出语音按钮宽度
        let voiceBtnWidth: CGFloat = kAudioMinWidth + kAudioMaxWidth * CGFloat(model.duration / 60)
    
        self.voiceButton.width  = min(voiceBtnWidth, kAudioMaxWidth)
        self.voiceButton.height = kChatBubbleImageViewHeight
        self.voiceButton.top    = self.nicknameLabel.bottom - kChatBubblePaddingTop

        self.vocieTimeLabel.top    = self.voiceButton.top - 3  // 减去3，保证可以水平居中
        self.vocieTimeLabel.height = self.voiceButton.height
        
        if model.fromMe! {
            self.voiceButton.left = UIScreen.width - kChatAvatarMarginLeft - kChatAvatarWidth - kChatBubbleMaginLeft
                - self.voiceButton.width
            
            self.vocieTimeLabel.left = self.voiceButton.left - self.vocieTimeLabel.width
            self.vocieTimeLabel.textAlignment = .right

        } else {
            self.voiceButton.left = kChatBubbleLeft
            
            self.vocieTimeLabel.left = self.voiceButton.right
            self.vocieTimeLabel.textAlignment = .left
        }
        
        // 消息状态布局
        if model.fromMe! {
            // 语音消息，发送消息的进度菊花布局
            self.activityView.left = self.vocieTimeLabel.left - 20
            self.activityView.top  = self.voiceButton.top + 15
            
            // 消息发送失败按钮
            failSendMsgButton.left = activityView.left
            failSendMsgButton.top  = activityView.top
        }
        
        // 图像控件，实现动画播放
        voiceButton.imageView?.animationDuration = 1.0
        if model.fromMe! {
            // 设置 animationImages
            self.voiceButton.imageView?.animationImages = [
                KDYAsset.Chat_Sender_Playing001.image,
                KDYAsset.Chat_Sender_Playing002.image,
                KDYAsset.Chat_Sender_Playing003.image
            ]
            
        } else {
            self.voiceButton.imageView?.animationImages = [
                KDYAsset.Chat_Receiver_Playing001.image,
                KDYAsset.Chat_Receiver_Playing002.image,
                KDYAsset.Chat_Receiver_Playing003.image
            ]
        }
    }
    
    class func layoutCellHeight(_ model: ChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        
        var height: CGFloat = kChatAvatarMarginTop + kChatBubblePaddingBottom
        height += kChatBubbleImageViewHeight
        model.cellHeight = height
        
        return height
    }
    
    // MARK: - Event Response 
    @IBAction func playVoiceAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        // 选中按钮，开始动画
        if sender.isSelected {
            self.voiceButton.imageView!.startAnimating()
            
        } else {  // 停止动画
            self.voiceButton.imageView!.stopAnimating()
        }
        
        guard let delegate = self.cellDelegate else { return }
        delegate.didClickCellVoiceAndPlaying(self, isPlaying: sender.isSelected)
    }
    
    /**
     *  停止播放语音动画
     */
    func stopPlayVoiceAnimation() {
        self.voiceButton.imageView?.stopAnimating()
        self.voiceButton.isSelected = false
    }
}

