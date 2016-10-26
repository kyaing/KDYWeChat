//
//  KDChatViewController+Delegate.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/24.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import Photos

// MARK: - ChatBarViewDelegate
extension KDChatViewController: ChatBarViewDelegate {

    /**
     *  显示表情键盘
     */
    func bottomBarViewShowEmotionKeyboard() {
        // 更新BarView和表情键盘的布局
        let emotionHeight = self.emotionView.height
        barPaddingBottomConstranit?.updateOffset(-emotionHeight)
        
        // 动画显示表情键盘
        UIView.animateWithDuration(
            0.25,
            delay: 0,
            options: .CurveEaseInOut,
            animations: {
                self.emotionView.snp_updateConstraints() { (make) in
                    make.top.equalTo(self.bottomBarView.snp_bottom)
                }
                
                // 同时隐藏扩展键盘
                self.shareView.snp_updateConstraints() { (make) in
                    make.top.equalTo(self.bottomBarView.snp_bottom).offset(self.view.height)
                }
                
                self.view.layoutIfNeeded()
                
        }) { (bool) in
        }
    }
    
    /**
     *  显示扩展键盘
     */
    func bottomBarViewShowShareKeyboard() {
        let shareHeight = self.shareView.height
        barPaddingBottomConstranit?.updateOffset(-shareHeight)
        
        UIView.animateWithDuration(
            0.25,
            delay: 0,
            options: .CurveEaseInOut,
            animations: {
                // 直接显示扩展键盘，覆盖在表情键盘之上
                self.shareView.snp_updateConstraints() { (make) in
                    make.top.equalTo(self.bottomBarView.snp_bottom)
                }
                self.view.layoutIfNeeded()
                
        }) { (bool) in
        }
    }
    
    /**
     *  点语音时隐藏自定义键盘
     */
    func bottomBarViewHideAllKeyboardWhenVoice() {
        self.hideCustomKeyboard()
    }
    
    /**
     Control the actionBarView height:
     We should make actionBarView's height to original value when the user wants to show recording keyboard.
     Otherwise we should make actionBarView's height to currentHeight
     
     - parameter showExpandable: show or hide expandable inputTextView
     */
    func controlExpandableInputView(showExpandable showExpandable: Bool) {
        let textView = self.bottomBarView.inputTextView
        let currentTextHeight = self.bottomBarView.inputTextViewCurrentHeight
        UIView.animateWithDuration(0.3) { () -> Void in
            let textHeight = showExpandable ? currentTextHeight : kBarViewHeight
            self.bottomBarView.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(textHeight)
            }
            
            self.view.layoutIfNeeded()
            self.chatTableView.scrollBottomToLastRow()
            textView.contentOffset = CGPoint.zero
        }
    }
}

// MARK: - UITextViewDelegate
extension KDChatViewController: UITextViewDelegate {
    /**
     *  将要进入到编辑模式
     */
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.bottomBarView.inputTextViewCallKeyboard()
        
        return true
    }
    
    /**
     *  内容发生改变时
     */
    func textViewDidChange(textView: UITextView) {
        
    }
    
    /**
     *  键盘内容即将输入到 textView 中时
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // 发送文本消息
            sendChatTextMessage(textView)
            
            return false
        }
        
        return true
    }
}

// MARK: - ChatEmotionViewDelegate
extension KDChatViewController: ChatEmotionViewDelegate {
    
}

// MARK: - ChatShareMoreViewDelegate
extension KDChatViewController: ChatShareMoreViewDelegate {
    /// 点击照片
    func didClickPhotoItemAction() {
        print("did Click PhotoItem")
        
        // 弹出 BSImagePicker 图片选择器 (可以最多一次性选择九张)
        self.ky_presentImagePickerController(
            maxNumberOfSelections: 1,  // 先发一张作为测试
            select: { (asset) in
                
            }, deselect: { (asset) in
                
            }, cancel: { (assets: [PHAsset]) in
                
            }, finish: { [weak self] (assets: [PHAsset]) in
                guard let strongSelf = self else { return }
                
                // 点击完成后，获取图片并上传图片
                if let image = assets[0].getUIImage() {
                    strongSelf.sendChatImageMessage(image)
                }
                
            }) { 
                print("completion")
            }
    }
    
    /// 点击拍照
    func didClickCamaraItemAction() {
        print("did Click CamaraItem")
        
    }
    
    /// 点击语音聊天
    func didClickAudioChatItemAction() {
        print("did Click AudioChatItem")
        
    }

    /// 点击视频聊天
    func didClickVideoChatItemAction() {
        print("did Click VideoChatItem")
        
    }
    
    /// 点击红包
    func didClickRedEnvelopeItemAction() {
        print("did Click RedEnvelopeItem")
        
    }
    
    /// 点击位置
    func didClickLocationItemAction() {
        print("did Click LocationItem")
        
    }
}

