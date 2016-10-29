//
//  RecordManager.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/29.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVFoundation

/// 录音管理类
class RecordManager: NSObject {
    
    /// 录音参数设置
    lazy var recordSetting: [String: AnyObject] = {
        let setting = [
            // 线性采样位数
            AVLinearPCMBitDepthKey: NSNumber(int: 16),
            // 设置录音格式
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM),
            // 录音通道数  1 或 2
            AVNumberOfChannelsKey: NSNumber(int: 1),
            // 设置录音采样率(Hz)
            AVSampleRateKey: NSNumber(float: 8000.0)]
        
        return setting
    }()
    
    var recorder: AVAudioRecorder!
    
    /// 录音开始时间
    var startTime: CFTimeInterval!

    /// 录音结束时间
    var endTime: CFTimeInterval!
    
    /// 录音时长
    var recordTimeInterval: CFTimeInterval!
    
    /// 是否结束录音
    var isFinishRecord: Bool = true
    
    /// 多媒体的代理
    weak var mediaDelegate: MediaManagerDelegate?
    
    static let shareInstance = RecordManager()
    private override init() {
        super.init()
    }
    
    /**
     *  开始录音
     */
    func startRecording() {
        // 开始时间，当前图层的时间
        self.startTime = CACurrentMediaTime()
        
        do {
            self.recorder = try AVAudioRecorder(URL: NSURL(string: "")!, settings: self.recordSetting)
            
        } catch let error as NSError {
            print("开始录音失败，error = \(error.description)")
        }
    }
    
    /**
     *  取消录音
     */
    func cancelRecording() {
        
    }
    
    /**
     *  更新录音音量
     */
    func updateVolume() {
        
    }
    
    /**
     *  停止录音
     */
    func stopRecording() {
        
    }
}

