//
//  RecordManager.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/29.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVFoundation

// 录音管理类
class RecordManager: NSObject {
    
    /// 录音参数设置
    lazy var recordSetting: [String: AnyObject] = {
        let setting = [
            // 线性采样位数  8、16、24、32
            AVLinearPCMBitDepthKey: NSNumber(value: 16 as Int32),
            // 设置录音格式  AVFormatIDKey == kAudioFormatLinearPCM
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM as UInt32),
            // 录音通道数  1 或 2
            AVNumberOfChannelsKey: NSNumber(value: 1 as Int32),
            // 设置录音采样率(Hz) 如：AVSampleRateKey == 8000/44100/96000（影响音频的质量）
            AVSampleRateKey: NSNumber(value: 8000.0 as Float)
            ]
        
        return setting
    }()
    
    var recorder: AVAudioRecorder!
    
    var operationQueue: OperationQueue! {
        get {
            return OperationQueue()
        }
    }
    
    /// 录音开始时间
    var startTime: CFTimeInterval!

    /// 录音结束时间
    var endTime: CFTimeInterval!
    
    /// 录音时长
    var recordingTimeInterval: NSNumber!
    
    /// 是否结束录音
    var isFinishRecord: Bool = true
    
    /// 是否取消录音
    var isCancelRecord: Bool = false
    
    /// 语音本地路径
    var recordingTempFilePath: URL!
    
    /// 多媒体的代理
    weak var mediaDelegate: MediaManagerDelegate?
    
    static let shareInstance = RecordManager()
    fileprivate override init() {
        super.init()
    }
    
    /**
     *  获取录音权限并初始化录音
     */
    func checkPermissionAndSetupRecord() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .duckOthers)
            do {
                try session.setActive(true)
                session.requestRecordPermission{allowed in
                    if !allowed {
                        
                    }
                }
            } catch _ as NSError {
                
            }
            
        } catch _ as NSError {
            
        }
    }
    
    /**
     *  开始录音
     */
    func startRecord() {
        
        self.isCancelRecord = false
        self.startTime = CACurrentMediaTime()
        
        do {
            // 根据时间，生成每条语音的路径
            let random = arc4random() % 100000
            let time: Int32 = (Int32)(Date().timeIntervalSince1970)
            let fileName = String(format: "%d%d", time, random)
            
            self.recordingTempFilePath = MediaFileManager.getRecordingFilePath(fileName)
            
            self.recorder = try AVAudioRecorder(url: self.recordingTempFilePath, settings: self.recordSetting)
            self.recorder.delegate = self
            self.recorder.isMeteringEnabled = true
            self.recorder.prepareToRecord()
            
        } catch _ as NSError {
            self.recorder = nil
        }
        
        self.perform(#selector(self.readyStartRecord), with: self, afterDelay: 0.0)
    }
    
    /**
     *  准备录音
     */
    func readyStartRecord() {
        setupAudioSessionCategory()
        
        self.recorder.record()
        
        let operation = BlockOperation()
        operation.addExecutionBlock(updateVolume)
        self.operationQueue.addOperation(operation)
    }
    
    /**
     *  取消录音
     */
    func cancelRecord() {
        self.isCancelRecord = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.readyStartRecord), object: self)
        self.isFinishRecord = false
        
        self.recorder.stop()
        self.recorder.deleteRecording()
        self.recorder = nil
    }
    
    /**
     *  更新录音音量
     */
    func updateVolume() {
        guard let recorder = self.recorder , self.recorder != nil else { return }
        
        repeat {
            recorder.updateMeters()
            
            self.recordingTimeInterval = NSNumber(value: NSNumber(value: recorder.currentTime as Double).int32Value as Int32)
            
            let averagePower = recorder.averagePower(forChannel: 0)
            let lowPassResults = pow(10, (0.05 * averagePower)) * 10
            
            dispatch_async_safely_to_main_queue({ () -> () in
                self.mediaDelegate?.updateRecordingVolumn(lowPassResults)
            })
            
            // 大于60秒，停止录音
            if self.recordingTimeInterval.int32Value > 60 {
                stopRecord()
            }
            
            Thread.sleep(forTimeInterval: 0.05)
            
        } while(recorder.isRecording)
    }
    
    /**
     *  停止录音
     */
    func stopRecord() {
        self.isFinishRecord = true
        self.isCancelRecord = false
        
        self.endTime = CACurrentMediaTime()
        
        if (self.endTime - self.startTime) < 0.5 {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.readyStartRecord), object: self)
            
            dispatch_async_safely_to_main_queue({ () -> () in
                self.mediaDelegate?.recordTimeTooShort()
            })
            
        } else {
            guard let currentTime: TimeInterval = self.recorder.currentTime , self.recorder != nil
                else { return }
            self.recordingTimeInterval = NSNumber(value: NSNumber(value: currentTime as Double).int32Value as Int32)
            
            if self.recordingTimeInterval.int32Value < 1 {
                self.perform(#selector(self.readyStopRecord), with: self, afterDelay: 0.5)
            } else {
                self.readyStopRecord()
            }
        }
        
        self.operationQueue.cancelAllOperations()
    }
    
    /**
     *  准备停止录音
     */
    func readyStopRecord() {
        self.recorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, with: .notifyOthersOnDeactivation)
        } catch _ as NSError {
            
        }
    }
    
    /**
     *  设置音频模式
     */
    func setupAudioSessionCategory() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            
        } catch let error as NSError {
            print("error = \(error.description)")
        }
    }
    
    func dispatch_async_safely_to_main_queue(_ block: @escaping ()->()) {
        dispatch_async_safely_to_queue(DispatchQueue.main, block)
    }
    
    func dispatch_async_safely_to_queue(_ queue: DispatchQueue, _ block: @escaping ()->()) {
        if queue === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            queue.async {
                block()
            }
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension RecordManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag && self.isFinishRecord {
            // 完成录音
            self.mediaDelegate?.recordFinished(self.recordingTempFilePath.absoluteString, duration: self.recordingTimeInterval.int32Value)
            
        } else {
            
        }
    }
}

