//
//  ChatAudioTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

let kAudioMaxWidth: CGFloat = 200

/// 聊天语音Cell
class ChatAudioTableCell: ChatBaseTableCell {

    /// 播放语音按钮
    @IBOutlet weak var voiceButton: UIButton!
    
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
        
        self.voiceButton.setBackgroundImage(bubbleImage, forState: .Normal)
        self.voiceButton.setBackgroundImage(bubbleImage, forState: .Highlighted)
        
        self.vocieTimeLabel.text = String(format:"%zd\"", Int(model.duration))
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }
        
        let voiceBtnWidth: CGFloat = 70 + 200 * CGFloat(model.duration / 60)
    
        self.voiceButton.width     = min(voiceBtnWidth, kAudioMaxWidth)
        self.voiceButton.height    = kChatBubbleImageViewHeight
        self.voiceButton.top       = self.nicknameLabel.bottom - kChatBubblePaddingTop

        self.vocieTimeLabel.top    = self.voiceButton.top
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
    @IBAction func playVoiceAction(sender: AnyObject) {
        
    }
}

