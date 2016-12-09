//
//  KDChatViewController+Delegate.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/24.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import Photos

// MARK: - UITextViewDelegate
extension KDChatViewController: UITextViewDelegate {
    /**
     *  将要进入到编辑模式
     */
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.bottomBarView.inputTextViewCallKeyboard()
        return true
    }
    
    /**
     *  内容发生改变时
     */
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    /**
     *  键盘内容即将输入到 textView 中时
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // 发送文本消息
            sendChatTextMessage(textView)
            
            return false
        }
        
        return true
    }
}

// MARK: - MediaManagerDelegate
extension KDChatViewController: MediaManagerDelegate {
    /**
     *  更新录音音量
     */
    func updateRecordingVolumn(_ value: Float) {
        self.recordingView.updateVolumeValue(value)
    }
    
    /**
     *  录音时间过短
     */
    func recordTimeTooShort() {
        self.recordingView.recordWithShortTime()
    }
    
    /**
     *  录音完成
     */
    func recordFinished(_ path: String, duration: Int32) {
        // 发送语音消息
        sendChatVoiceMessage(path, duration: duration)
    }
    
    /**
     *  播放语音结束
     */
    func palyVoiceFinished() {
        self.currentVoiceCell.stopPlayVoiceAnimation()
    }
    
    /**
     *  播放语音失败
     */
    func playVoiceFailed() {
        self.currentVoiceCell.stopPlayVoiceAnimation()
    }
}

// MARK: - ChatCellActionDelegate
extension KDChatViewController: ChatCellActionDelegate {
    
    /**
     *  点击头像
     */
    func didClickCellAavator(_ cell: ChatBaseTableCell) {
        guard let model = cell.model else { return }
        ky_pushViewController(KDPersonalDetailViewController(model: model), animated: true)
    }
    
    /**
     *  点击图片
     */
    func didClickCellWithImageView(_ cell: ChatBaseTableCell) {
        print("didClickCellWithImageView")
    }
    
    /**
     *  点击地理位置
     */
    func didClickCellWithLocations(_ cell: ChatBaseTableCell) {
        print("didClickCellWithLocations")
    }
    
    /**
     *  播放语音
     */
    func didClickCellVoiceAndPlaying(_ cell: ChatAudioTableCell, isPlaying: Bool) {
        if self.currentVoiceCell != nil && self.currentVoiceCell != cell {
            self.currentVoiceCell.stopPlayVoiceAnimation()
        }
        
        guard let model = cell.model else { return }
        
        if isPlaying {
            self.currentVoiceCell = cell
            PlayMediaManger.shareInstance.startPlayingVoice(model)
            
        } else {
            PlayMediaManger.shareInstance.stopPlayingVoice()
        }
    }
    
    /**
     *  播放视频
     */
    func didClickCellVideoAndPlaying(_ cell: ChatBaseTableCell, isPlaying: Bool) {
        print("didClickCellVideoAndPlaying")
    }
    
    /**
     *  重发消息
     */
    func didClickCellAndReSendMessage(_ cell: ChatBaseTableCell) {
        print("didClickCellAndReSendMessage")
    }
}

// MARK: - ChatBarViewDelegate
extension KDChatViewController: ChatBarViewDelegate {

    /**
     *  显示表情键盘
     */
    func bottomBarViewShowEmotionKeyboard() {
        // 更新BarView和表情键盘的布局
        let emotionHeight = self.emotionView.height
        barPaddingBottomConstranit?.updateOffset(-emotionHeight)
        
        // 动画显示表情键盘，同时隐藏扩展键盘
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.25)
        self.emotionView.snp_updateConstraints() { (make) in
            make.top.equalTo(self.bottomBarView.snp_bottom)
        }
        // 同时隐藏扩展键盘
        self.shareView.snp_updateConstraints() { (make) in
            make.top.equalTo(self.bottomBarView.snp_bottom).offset(self.view.height)
        }
        UIView.commitAnimations()
    }
    
    /**
     *  显示扩展键盘
     */
    func bottomBarViewShowShareKeyboard() {
        let shareHeight = self.shareView.height
        barPaddingBottomConstranit?.updateOffset(-shareHeight)
        
        // 直接显示扩展键盘，覆盖在表情键盘之上
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.25)
        self.shareView.snp_updateConstraints() { (make) in
            make.top.equalTo(self.bottomBarView.snp_bottom)
        }
        UIView.commitAnimations()
    }
    
    /**
     *  点语音时隐藏自定义键盘
     */
    func bottomBarViewHideAllKeyboardWhenVoice() {
        hideCustomKeyboard()
    }
    
    /**
     *  Control the actionBarView height:
     *  We should make actionBarView's height to original value when the user wants to show recording keyboard.
     *  Otherwise we should make actionBarView's height to currentHeight
     
     -  parameter showExpandable: show or hide expandable inputTextView
     */
    func controlExpandableInputView(showExpandable: Bool) {
        let textView = self.bottomBarView.inputTextView
        let currentTextHeight = self.bottomBarView.inputTextViewCurrentHeight
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let textHeight = showExpandable ? currentTextHeight : kBarViewHeight
            self.bottomBarView.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(textHeight)
            }
            
            self.view.layoutIfNeeded()
            self.chatTableView.scrollBottomToLastRow()
            textView?.contentOffset = CGPoint.zero
        }) 
    }
}

// MARK: - ChatEmotionViewDelegate
extension KDChatViewController: ChatEmotionViewDelegate {
    
}

// MARK: - ChatShareMoreViewDelegate
extension KDChatViewController: ChatShareMoreViewDelegate {
    /// 点击照片
    func didClickPhotoItemAction(_ photoCounts: Int) {
        print("did Click PhotoItem")
        
        // 弹出 BSImagePicker 图片选择器 (最多一次性选择九张)
        ky_presentImagePickerController(
            maxNumberOfSelections: photoCounts,
            select: { (asset) in
                
            }, deselect: { (asset) in
                
            }, cancel: { (assets: [PHAsset]) in
                
            }, finish: { [weak self] (assets: [PHAsset]) in
                guard let strongSelf = self else { return }
                
                // 点击完成后，获取图片并上传图片
                for index in 1...photoCounts {
                    if let image = assets[index-1].getUIImage() {
                        strongSelf.sendChatImageMessage(image)
                    }
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

        ky_presentViewController(KDChatLocationViewController(), animated: true) {
            print("模态弹出位置页面")
        }
    }
}

