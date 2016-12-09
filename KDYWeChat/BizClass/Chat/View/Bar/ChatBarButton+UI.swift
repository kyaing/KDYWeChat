//
//  ChatBarButton+UI.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/22.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

// MARK: - 按钮状态的改变
extension UIButton {
    // 控制语音按钮切换成键盘图标
    func voiceButtonChangeToKeyboardUI(showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(UIImage(named: "tool_keyboard_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_keyboard_2"), for: .highlighted)
            
        } else {
            self.setImage(UIImage(named: "tool_voice_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_voice_2"), for: .highlighted)
        }
    }
    
    // 控制表情按钮切换成键盘图标
    func emotionButtonChangeToKeyboardUI(showKeyboard: Bool) {
        if showKeyboard {
            self.setImage(UIImage(named: "tool_keyboard_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_keyboard_2"), for: .highlighted)
            
        } else {
            self.setImage(UIImage(named: "tool_emotion_1"), for: UIControlState())
            self.setImage(UIImage(named: "tool_emotion_2"), for: .highlighted)
        }
    }
    
    // 控制录音按钮的UI
    func replaceRecordButtonUI(isRecording: Bool) {
        if isRecording {
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#C6C7CB")), for: .Normal)
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#F3F4F8")), for: .Highlighted)
            
        } else {
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#F3F4F8")), for: .Normal)
            self.setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: "#C6C7CB")), for: .Highlighted)
        }
    }
}

