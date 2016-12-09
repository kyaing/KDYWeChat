//
//  MediaManagerDelegate.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/29.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

/// 媒体类 Delegate
protocol MediaManagerDelegate: class {
    /**
     *  更新录音音量
     */
    func updateRecordingVolumn(_ value: Float)
    
    /**
     *  录音时间过短
     */
    func recordTimeTooShort()
    
    /**
     *  录音完成
     */
    func recordFinished(_ path: String, duration: Int32)
    
    /**
     *  播放语音完成
     */
    func palyVoiceFinished()
    
    /**
     *  暂停播放语音
     */
    
    /**
     *  停止播放语音
     */
    
    /**
     *  语音播放失败
     */
    func playVoiceFailed()
}

