//
//  ChatBottomBarView.swift
//  KDYWeChat
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

// MARK: -  ChatBarViewDelegate
protocol ChatBarViewDelegate: class {
    // 显示表情键盘
    func bottomBarViewShowEmotionKeyboard()
    
    // 显示扩展键盘
    func bottomBarViewShowShareKeyboard()
    
    // 当语音时隐藏所有自定义键盘
    func bottomBarViewHideAllKeyboardWhenVoice()
}

// MARK: - ChatBottomBarView
class ChatBottomBarView: UIView, NibReusable {
    
    // 键盘类型
    enum ChatBarKeyboardType: Int {
        case `default`
        case text
        case emotion
        case share
    }
    
    // 按着录音按钮
    @IBOutlet weak var recordButton: UIButton! {
        didSet {
            // recordButton是自定义按钮
            recordButton.setBackgroundImage(UIImage.imageWithColor(KDYColor.RecordBgNormal.color), for: .normal)
            recordButton.setBackgroundImage(UIImage.imageWithColor(KDYColor.RecordBgSelect.color), for: .highlighted)
            recordButton.layer.borderColor = UIColor.gray.cgColor
            recordButton.layer.cornerRadius  = 5.0
            recordButton.layer.borderWidth   = 0.5
            recordButton.layer.masksToBounds = true
            recordButton.isHidden = true
        }
    }
    
    // 文本输入框
    @IBOutlet weak var inputTextView: UITextView! {
        didSet {
            inputTextView.backgroundColor     = UIColor(colorHex: "#f8fefb")
            inputTextView.layer.borderColor   = UIColor(colorHex: "#C2C3C7")?.cgColor
            inputTextView.layer.borderWidth   = 1.0
            inputTextView.layer.cornerRadius  = 5.0
            inputTextView.layer.masksToBounds = true
            inputTextView.textContainerInset  = UIEdgeInsetsMake(10, 5, 5, 5)
            inputTextView.returnKeyType       = .send
            inputTextView.font = UIFont.systemFont(ofSize: 15)
            inputTextView.enablesReturnKeyAutomatically = true
            inputTextView.isHidden = false
        }
    }
    
    @IBOutlet weak var audioButton: ChatBarButton!
    @IBOutlet weak var emotionButton: ChatBarButton!
    @IBOutlet weak var shareButton: ChatBarButton!
    
    weak var delegate: ChatBarViewDelegate?
    var keyboardType: ChatBarKeyboardType? = .default
    var inputTextViewCurrentHeight: CGFloat = kBarViewHeight
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        addBarLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBarLayer()
    }

    func addBarLayer() {
        self.layer.borderColor = UIColor(colorHex: "#C2C3C7")?.cgColor
        self.layer.borderWidth = 0.5
    }
}

extension ChatBottomBarView {
    /**
     *  改变按钮状态
     */
    func setupBtnUIStatus() {
        audioButton.setImage(UIImage(named: "tool_voice_1"), for: UIControlState())
        audioButton.setImage(UIImage(named: "tool_voice_2"), for: .highlighted)
        
        emotionButton.setImage(UIImage(named: "tool_emotion_1"), for: UIControlState())
        emotionButton.setImage(UIImage(named: "tool_emotion_2"), for: .highlighted)
        
        shareButton.setImage(UIImage(named: "tool_share_1"), for: UIControlState())
        shareButton.setImage(UIImage(named: "tool_share_2"), for: .highlighted)
    }
    
    /**
     *  显示录音状态
     */
    func showAudioRecording() {
        keyboardType = .default
        
        inputTextView.isHidden = true
        inputTextView.resignFirstResponder()
        
        if let delegate = delegate {
            delegate.bottomBarViewHideAllKeyboardWhenVoice()
        }
        
        recordButton.isHidden = false
        audioButton.showTypingKeyboard   = true
        emotionButton.showTypingKeyboard = false
        shareButton.showTypingKeyboard   = false
    }
    
    /**
     *  显示文字输入键盘
     */
    func showTypingKeyboard() {
        keyboardType = .text
        
        inputTextView.isHidden = false
        inputTextView.becomeFirstResponder()
        
        // 操作其它按钮
        recordButton.isHidden = true
        audioButton.showTypingKeyboard   = false
        emotionButton.showTypingKeyboard = true
        shareButton.showTypingKeyboard   = true
    }
    
    /**
     *  显示表情键盘
     */
    func showEmotionKeyboard() {
        keyboardType = .emotion
        
        inputTextView.isHidden = false
        inputTextView.resignFirstResponder()
        
        if let delegate = delegate {
            delegate.bottomBarViewShowEmotionKeyboard()
        }
        
        recordButton.isHidden = true
        audioButton.showTypingKeyboard   = false
        emotionButton.showTypingKeyboard = false
        shareButton.showTypingKeyboard   = true
    }
    
    /**
     *  显示扩展键盘
     */
    func showShardKeyboard() {
        keyboardType = .share
        
        inputTextView.isHidden = false
        inputTextView.resignFirstResponder()
        
        if let delegate = delegate {
            delegate.bottomBarViewShowShareKeyboard()
        }
        
        recordButton.isHidden = true
        audioButton.showTypingKeyboard   = false
        emotionButton.showTypingKeyboard = true
        shareButton.showTypingKeyboard   = false
    }
 
    /**
     *  当显示表情或扩展自定义键盘时，点击输入框唤起系统键盘
     */
    func inputTextViewCallKeyboard() {
        keyboardType = .text
        inputTextView.isHidden = false
        
        // 同时恢复表情按钮图标
        emotionButton.emotionButtonChangeToKeyboardUI(false)
        
        recordButton.isHidden = true
        audioButton.showTypingKeyboard   = false
        emotionButton.showTypingKeyboard = false
        shareButton.showTypingKeyboard   = false
    }
    
    /**
     *  取消用户输入
     */
    func resignKeyboardInput() {
        keyboardType = .default
        inputTextView.resignFirstResponder()
        
        emotionButton.showTypingKeyboard = true
        shareButton.showTypingKeyboard   = true
    }
}

