//
//  MediaFileManager.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/10/30.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

private let audioRecordDirectory = "ChatRecording"
private let videoRecordDirectory = "ChatVideo"

/// 多媒体文件管理类
class MediaFileManager: NSObject {
    
    /// 语音文件目录
    class var recordingDirecotry: NSURL {
        get {
            return createFilesDirectory(audioRecordDirectory)
        }
    }
    
    // 视频文件目录
    class var videoDirecotry: NSURL {
        get {
            return createFilesDirectory(videoRecordDirectory)
        }
    }
    
    /**
     *  创建文件的目录
     */
    class func createFilesDirectory(directoryName: String) -> NSURL {
        let documentDirectory = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first
        
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = documentDirectory?.URLByAppendingPathComponent(directoryName)
        
        if !fileManager.fileExistsAtPath((directoryURL?.absoluteString)!) {
            do {
                try fileManager.createDirectoryAtPath((directoryURL?.path)!, withIntermediateDirectories: true, attributes: nil)
                return directoryURL!
                
            } catch let error as NSError {
                print("error = \(error.description)")
            }
        }
        
        return directoryURL!
    }
    
    /**
     *  获取语音文件的路径
     */
    class func getRecordingFilePath(fileName: String) -> NSURL {
        // 这里直接使用苹果的语音格式 .wav，而不用 .amr
        return self.recordingDirecotry.URLByAppendingPathComponent("\(fileName)" + ".wav")
    }
    
    /**
     *  获取视频文件的路径
     */
    class func getVideoFilePath(fileName: String) -> NSURL {
        return self.videoDirecotry.URLByAppendingPathComponent("\(fileName)" + ".mp4")
    }
}

