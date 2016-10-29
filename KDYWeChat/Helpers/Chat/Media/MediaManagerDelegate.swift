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
    func recordUpdateVolumn(value: Float)
    
    /**
     *  录音时间过短
     */
    func recordTimeTooShort()
    
    /**
     *  录音完成
     */
    func recordFinish(path: String, duration: Int)
}

