//
//  PlayMediaManger.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/29.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVFoundation

/// 播放媒体管理类
class PlayMediaManger: NSObject {
    
    var audioPlayer: AVAudioPlayer!
    
    weak var mediaDelegate: MediaManagerDelegate?
    
    static let shareInstance = PlayMediaManger()
    private override init() {
        super.init()
    }
    
    // MARK: - Voice Methods
    func startPlayingVoice(model: ChatModel) {
        // 播放 .wav格式的语音
        let voiceBody = model.message.body as! EMVoiceMessageBody
        let status = voiceBody.downloadStatus
    
        if status == EMDownloadStatusDownloading {
            print("语音正式下载中"); return
            
        } else if status == EMDownloadStatusFailed {
            EMClient.sharedClient().chatManager.downloadMessageThumbnail(model.message, progress: nil, completion: nil)
        }
        
        if let path = model.localFilePath {
            playVoiceWithPath(path)
        }
    }
    
    func stopPlayingVoice() {
        if self.audioPlayer == nil { return }
        
        self.audioPlayer.stop()
        self.audioPlayer.delegate = nil
        self.audioPlayer = nil
        
        // 播放停止后，关闭此功能
        UIDevice.currentDevice().proximityMonitoringEnabled = false
    }
    
    private func playVoiceWithPath(path: String) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            
            guard let audioPlayer = self.audioPlayer else { return }
            
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            
            guard let mediaDelegate = self.mediaDelegate else { return }
            
            if audioPlayer.play() {
                // 开始红外感应，用于切换听筒与扬声器
                UIDevice.currentDevice().proximityMonitoringEnabled = true
            } else {
                mediaDelegate.playVoiceFailed()
            }
            
        } catch {
            stopPlayingVoice()
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension PlayMediaManger: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        UIDevice.currentDevice().proximityMonitoringEnabled = false
        
        guard let mediaDelegate = self.mediaDelegate else { return }
        if flag {
            mediaDelegate.palyVoiceFinished()
            
        } else {
            mediaDelegate.playVoiceFailed()
        }
    }
}

