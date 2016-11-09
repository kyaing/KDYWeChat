//
//  AlumbBodyView.swift
//  KDYWeChat
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

enum AlumbBodyType {
    case Text
    case Image
    case Video
}

/// 朋友圈正文部分
class AlumbBodyView: UIView {
    
    /// 文本
    var content: UITextView!
    /// 图片 (先展示一张)
    var picture: UIImageView?

}

