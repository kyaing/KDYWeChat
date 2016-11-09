//
//  KDChatViewController+ChatBarView.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/22.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - ChatBarView
extension KDChatViewController {
    
    /**
     *  处理各个按钮即语音，表情，扩展及录音按钮的点击交互
     */
    func setupBarViewInteraction() {
        let voiceButton: ChatBarButton   = bottomBarView.audioButton    // 语音按钮
        let emotionButton: ChatBarButton = bottomBarView.emotionButton  // 表情按钮
        let shareButton: ChatBarButton   = bottomBarView.shareButton    // 扩展按钮
        let recordButton: UIButton       = bottomBarView.recordButton   // 录音按钮
        let inputTextView: UITextView    = bottomBarView.inputTextView  // 文本输入框
        
        // 点击语音按钮
        voiceButton.rx_tap.subscribeNext { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.bottomBarView.setupBtnUIStatus()
            
            // 根据录音按钮是否显示判断键盘的不同状态
            let showRecording = strongSelf.bottomBarView.recordButton.hidden
            if showRecording {  // 当录音按钮隐藏
                strongSelf.bottomBarView.showAudioRecording()
                voiceButton.voiceButtonChangeToKeyboardUI(showKeyboard: true)
                strongSelf.controlExpandableInputView(showExpandable: false)
                
            } else {
                strongSelf.bottomBarView.showTypingKeyboard()
                voiceButton.voiceButtonChangeToKeyboardUI(showKeyboard: false)
                strongSelf.controlExpandableInputView(showExpandable: true)
            }
            
        }.addDisposableTo(disposeBag)
        
        // 点击表情按钮
        emotionButton.rx_tap.subscribeNext { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.bottomBarView.setupBtnUIStatus()
            
            // 改变表情按钮UI
            emotionButton.emotionButtonChangeToKeyboardUI(showKeyboard: !emotionButton.showTypingKeyboard)
            
            if emotionButton.showTypingKeyboard {  // 当显示表情键盘
                strongSelf.bottomBarView.showTypingKeyboard()
                
            } else {
                strongSelf.bottomBarView.showEmotionKeyboard()
            }
            
            strongSelf.controlExpandableInputView(showExpandable: true)
            
        }.addDisposableTo(disposeBag)
        
        // 点击扩展按钮
        shareButton.rx_tap.subscribeNext { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.bottomBarView.setupBtnUIStatus()
            
            if shareButton.showTypingKeyboard {
                strongSelf.bottomBarView.showTypingKeyboard()
            } else {
                strongSelf.bottomBarView.showShardKeyboard()
            }
            
            strongSelf.controlExpandableInputView(showExpandable: true)
            
        }.addDisposableTo(disposeBag)
        
        // 录音按钮 (添加长按手势)
        var finishRecording: Bool = true
        let longPressGesture = UILongPressGestureRecognizer()
        recordButton.addGestureRecognizer(longPressGesture)
        longPressGesture.rx_event.subscribeNext { event in

            let state = event.state
            switch state {
            case .Began:  // 开始录音
                finishRecording = true
                
                self.recordingView.recording()
                RecordManager.shareInstance.startRecord()
                recordButton.replaceRecordButtonUI(isRecording: true)
                
            case .Changed:  // 录音移动中 (如上滑取消录音)
                // 判断手势移动的Point，是否在视图中
                let point = event.locationInView(self.recordingView)
                if self.recordingView.pointInside(point, withEvent: nil) {
                    self.recordingView.cancelRecordBySldeUp()
                    finishRecording = false
                } else {
                    self.recordingView.recording()
                    finishRecording = true
                }
                
            case .Ended:  // 录音结束
                if finishRecording {
                    RecordManager.shareInstance.stopRecord()
                } else {
                    RecordManager.shareInstance.cancelRecord()
                }
                self.recordingView.stopRecording()
                recordButton.replaceRecordButtonUI(isRecording: false)
                
            default: break
            }
        }.addDisposableTo(disposeBag)
        
        // 点击文本框 (添加点击手势)
        let tapGesture = UITapGestureRecognizer()
        inputTextView.addGestureRecognizer(tapGesture)
        tapGesture.rx_event.subscribeNext { (event) in
            
            inputTextView.becomeFirstResponder()
            inputTextView.inputView = nil
            inputTextView.reloadInputViews()
            
        }.addDisposableTo(disposeBag)
    }
}

