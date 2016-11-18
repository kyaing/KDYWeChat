//
//  ChatButton.swift
//  KDYWeChat
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

class ChatBarButton: UIButton {
    var showTypingKeyboard: Bool
    
    required init?(coder aDecoder: NSCoder) {
        // 默认是显示文本键盘
        showTypingKeyboard = true
        super.init(coder: aDecoder)
    }
}

