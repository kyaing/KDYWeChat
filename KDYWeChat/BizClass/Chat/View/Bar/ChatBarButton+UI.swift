//
//  ChatBarButton+UI.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/22.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

// MARK: - 按钮状态的改变
extension UIButton {
    // 控制语音按钮切换成键盘图标
    func voiceButtonChangeToKeyboardUI(_ showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(UIImage(named: "tool_keyboard_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_keyboard_2"), for: .highlighted)
            
        } else {
            self.setImage(UIImage(named: "tool_voice_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_voice_2"), for: .highlighted)
        }
    }
    
    // 控制表情按钮切换成键盘图标
    func emotionButtonChangeToKeyboardUI(_ showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(UIImage(named: "tool_keyboard_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_keyboard_2"), for: .highlighted)
            
        } else {
            self.setImage(UIImage(named: "tool_emotion_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_emotion_2"), for: .highlighted)
        }
    }
    
    // 控制录音按钮的UI
    func replaceRecordButtonUI(_ isRecording: Bool) {
        if isRecording {
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(colorHex: "#C6C7CB")!), for: .normal)
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(colorHex: "#F3F4F8")!), for: .highlighted)
            
        } else {
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(colorHex: "#F3F4F8")!), for: .normal)
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(colorHex: "#C6C7CB")!), for: .highlighted)
        }
    }
}

