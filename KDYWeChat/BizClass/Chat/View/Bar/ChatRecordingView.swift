//
//  ChatRecordingView.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/29.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

/// 录音视图
class ChatRecordingView: UIView, NibReusable {
    
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
        
        self.backgroundColor = UIColor.clear
        self.centerView.layer.cornerRadius  = 5
        self.centerView.layer.masksToBounds = true
        self.tipsLabel.backgroundColor = UIColor.clear
    }
}

extension ChatRecordingView {
    /**
     *  正在录音
     */
    func recording() {
        self.isHidden = false
        
        self.cancelRecrodImageView.isHidden = true
        self.tooShortImageView.isHidden = true
        
        self.recordingBgView.isHidden = false
        self.tipsLabel.backgroundColor = UIColor.clear
        self.tipsLabel.text = "手指上滑，取消发送"
    }
    
    /**
     *  录音过短
     */
    func recordWithShortTime() {
        self.isHidden = false
        
        self.cancelRecrodImageView.isHidden = true
        self.tooShortImageView.isHidden = false
        
        self.recordingBgView.isHidden = true
        self.tipsLabel.text = "说话时间太短"
        
        // 0.5秒后消失
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.stopRecording()
        }
    }
    
    /**
     *  上滑取消录音
     */
    func cancelRecordBySldeUp() {
        self.isHidden = false
        
        self.cancelRecrodImageView.isHidden = false
        self.tooShortImageView.isHidden = true
        
        self.recordingBgView.isHidden = true
        self.tipsLabel.backgroundColor = UIColor.red
        self.tipsLabel.text = "松开手指，取消发送"
    }
    
    /**
     *  更新录音音量
     */
    func updateVolumeValue(_ value: Float) {
        var index = Int(round(value))
        index = index > 7 ? 7 : index
        index = index < 0 ? 0 : index
        
        let imageArray = [
            KDYAsset.Chat_Recording001.image,
            KDYAsset.Chat_Recording002.image,
            KDYAsset.Chat_Recording003.image,
            KDYAsset.Chat_Recording004.image,
            KDYAsset.Chat_Recording005.image,
            KDYAsset.Chat_Recording006.image,
            KDYAsset.Chat_Recording007.image,
            KDYAsset.Chat_Recording008.image
            ]
        self.recordingVolumeImage.image = imageArray[index]
    }
    
    /**
     *  结束录音
     */
    func stopRecording() {
        self.isHidden = true
    }
}

