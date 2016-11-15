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
            voiceButton.backgroundColor = UIColor.clearColor()
        }
    }
    
    /// 语音时长标签
    @IBOutlet weak var vocieTimeLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupCellContent(model: ChatModel) {
        super.setupCellContent(model)
    
        // 拉伸气泡图片，设置语音按钮背景图片
        let stretchImage = (model.fromMe!) ? UIImage(named: "SenderTextNodeBkg") : UIImage(named: "ReceiverTextNodeBkg")
        let bubbleImage = stretchImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .Stretch)
        
        // 设置语音按钮高亮时的背景图片
        let stretchHLImage = (model.fromMe!) ? UIImage(named: "SenderTextNodeBkgHL") : UIImage(named: "ReceiverTextNodeBkgHL")
        let bubbleHLImage  = stretchHLImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(30, 28, 85, 28), resizingMode: .Stretch)
        
        self.voiceButton.setBackgroundImage(bubbleImage, forState: .Normal)
        self.voiceButton.setBackgroundImage(bubbleHLImage, forState: .Highlighted)
        
        // 设置语音按钮播放图片
        let voiceImage = (model.fromMe!) ? UIImage(named: "SenderVoiceNodePlaying") : UIImage(named: "ReceiverVoiceNodePlaying")
        self.voiceButton.setImage(voiceImage, forState: .Normal)
        
        // 设置语音按钮，图片的内边距与对齐方式
        self.voiceButton.imageEdgeInsets = (model.fromMe!) ? UIEdgeInsetsMake(-kChatBubbleBottomTransparentHeight, 0, 0, kChatVoicePlayingMarginLeft) : UIEdgeInsetsMake(-kChatBubbleBottomTransparentHeight, kChatVoicePlayingMarginLeft, 0, 0)
        self.voiceButton.contentHorizontalAlignment = (model.fromMe!) ? .Right : .Left

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
            self.vocieTimeLabel.textAlignment = .Right

        } else {
            self.voiceButton.left = kChatBubbleLeft
            
            self.vocieTimeLabel.left = self.voiceButton.right
            self.vocieTimeLabel.textAlignment = .Left
        }
        
        // 消息状态布局
        if model.fromMe! {
            // 语音消息，发送消息的进度菊花布局
            self.activityView.left = self.vocieTimeLabel.left - 20
            self.activityView.top  = self.voiceButton.top + 15
            
            // 消息发送失败按钮
            self.failSendMsgButton.left = self.activityView.left
            self.failSendMsgButton.top  = self.activityView.top
        }
        
        // 图像控件，实现动画播放
        self.voiceButton.imageView?.animationDuration = 1.0
        if model.fromMe! {
            // 设置 animationImages
            self.voiceButton.imageView?.animationImages = [
                UIImage(named: "SenderVoiceNodePlaying001")!,
                UIImage(named: "SenderVoiceNodePlaying002")!,
                UIImage(named: "SenderVoiceNodePlaying003")!
            ]
            
        } else {
            self.voiceButton.imageView?.animationImages = [
                UIImage(named: "ReceiverVoiceNodePlaying001")!,
                UIImage(named: "ReceiverVoiceNodePlaying002")!,
                UIImage(named: "ReceiverVoiceNodePlaying003")!
            ]
        }
    }
    
    class func layoutCellHeight(model: ChatModel) -> CGFloat {
        if model.cellHeight != 0 {
            return model.cellHeight
        }
        
        var height: CGFloat = kChatAvatarMarginTop + kChatBubblePaddingBottom
        height += kChatBubbleImageViewHeight
        model.cellHeight = height
        
        return height
    }
    
    // MARK: - Event Response 
    @IBAction func playVoiceAction(sender: UIButton) {
        sender.selected = !sender.selected
        
        // 选中按钮，开始动画
        if sender.selected {
            self.voiceButton.imageView!.startAnimating()
            
        } else {  // 停止动画
            self.voiceButton.imageView!.stopAnimating()
        }
        
        guard let delegate = self.cellDelegate else { return }
        delegate.didClickCellVoiceAndPlaying(self, isPlaying: sender.selected)
    }
    
    /**
     *  停止播放语音动画
     */
    func stopPlayVoiceAnimation() {
        self.voiceButton.imageView?.stopAnimating()
        self.voiceButton.selected = false
    }
}

