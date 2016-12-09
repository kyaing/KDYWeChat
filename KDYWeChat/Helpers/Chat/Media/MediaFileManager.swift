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
    class var recordingDirecotry: URL {
        get {
            return createFilesDirectory(audioRecordDirectory)
        }
    }
    
    // 视频文件目录
    class var videoDirecotry: URL {
        get {
            return createFilesDirectory(videoRecordDirectory)
        }
    }
    
    /**
     *  创建文件的目录
     */
    class func createFilesDirectory(_ directoryName: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        
        let fileManager = FileManager.default
        let directoryURL = documentDirectory?.appendingPathComponent(directoryName)
        
        if !fileManager.fileExists(atPath: (directoryURL?.absoluteString)!) {
            do {
                try fileManager.createDirectory(atPath: (directoryURL?.path)!, withIntermediateDirectories: true, attributes: nil)
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
    class func getRecordingFilePath(_ fileName: String) -> URL {
        // 这里直接使用苹果的语音格式 .wav，而不用 .amr
        return self.recordingDirecotry.appendingPathComponent("\(fileName)" + ".wav")
    }
    
    /**
     *  获取视频文件的路径
     */
    class func getVideoFilePath(_ fileName: String) -> URL {
        return self.videoDirecotry.appendingPathComponent("\(fileName)" + ".mp4")
    }
}

