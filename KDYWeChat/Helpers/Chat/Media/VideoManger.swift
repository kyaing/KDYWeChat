//
//  VideoManger.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/29.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 录视频管理类
class VideoManger: NSObject {
    
    weak var mediaDelegate: MediaManagerDelegate?
    
    static let shareInstance = VideoManger()
    fileprivate override init() {
        super.init()
    }
}

