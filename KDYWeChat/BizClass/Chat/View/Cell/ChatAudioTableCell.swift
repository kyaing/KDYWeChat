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
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let model = self.model else { return }
        
        let voiceBtnWidth = 70 + 130 * CGFloat(model.duration / 60)
        self.voiceButton.width = min(voiceBtnWidth, kAudioMaxWidth)
        
        if model.fromMe! {

        } else {
            
        }
    }
    
    class func layoutCellHeight(model: ChatModel) -> CGFloat {
        return 40
    }
    
    // MARK: - Event Response 
    @IBAction func playVoiceAction(sender: AnyObject) {
        
    }
}

