//
//  ChatLocationTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Reusable

/// 聊天位置Cell
class ChatLocationTableCell: ChatBaseTableCell, NibReusable {

    /// 地址背景视图
    @IBOutlet weak var addressView: UIView!
    
    /// 地址详细信息
    @IBOutlet weak var addressLabel: UILabel!
    
    /// 地址部分的截图
    @IBOutlet weak var addressImageView: UIImageView!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setupCellContent(model: ChatModel) {
        super.setupCellContent(model)
        
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    class func layoutCellHeight(model: ChatModel) -> CGFloat {
        return 0
    }
}

