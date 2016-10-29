//
//  ChatRecordingView.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/29.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 录音视图
class ChatRecordingView: UIView {
    
    /// 录音承载视图
    @IBOutlet weak var centerView: UIView!
    
    /// 提示文本
    @IBOutlet weak var tipsLabel: UILabel!

    /// 语音时长过短图标
    @IBOutlet weak var tooShortImageView: UIImageView!
    
    /// 上滑取消录音图标
    @IBOutlet weak var cancelRecrodImageView: UIImageView!
    
    /// 录音背景视图
    @IBOutlet weak var recordingBgView: UIView!
    
    /// 录音中的图标
    @IBOutlet weak var recordingImageView: UIImageView!
    
    /// 录音中音量的图标
    @IBOutlet weak var recordingVolumeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.centerView.layer.cornerRadius  = 5
        self.centerView.layer.masksToBounds = true
        self.tipsLabel.backgroundColor = UIColor.clearColor()
    }
}

extension ChatRecordingView {
    /**
     *  正在录音
     */
    func recording() {
        self.hidden = false
        
        self.cancelRecrodImageView.hidden = true
        self.tooShortImageView.hidden = true
        
        self.recordingBgView.hidden = false
        self.tipsLabel.text = "手指上滑，取消发送"
    }
    
    /**
     *  录音过短
     */
    func recordWithShortTime() {
        self.hidden = false
        
        self.cancelRecrodImageView.hidden = true
        self.tooShortImageView.hidden = false
        
        self.recordingBgView.hidden = true
        self.tipsLabel.text = "说话时间太短"
        
        // 0.5秒后消失
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.stopRecording()
        }
    }
    
    /**
     *  上滑取消录音
     */
    func cancelRecordBySldeUp() {
        self.hidden = false
        
        self.cancelRecrodImageView.hidden = false
        self.tooShortImageView.hidden = true
        
        self.recordingBgView.hidden = true
        self.tipsLabel.backgroundColor = UIColor.redColor()
        self.tipsLabel.text = "松开手指，取消发送"
    }
    
    /**
     *  更新录音音量
     */
    func updateVolumeValue(valeu: Float) {
        
    }
    
    /**
     *  结束录音
     */
    func stopRecording() {
        self.hidden = true
    }
}

