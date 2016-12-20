//
//  MeCenterTableCell.swift
//  KDYWeChat
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit
import SnapKit

/// 静态页面统一的Cell
class MeCenterTableCell: UITableViewCell {
    
    // MARK: - Parameters
    
    /// 标题
    var _textLabel: UILabel?
    
    /// 标题左侧图片
    var _iamgeView: UIImageView?
    
    /// 右侧箭头
    var _indictor:  UIImageView?
    
    /// 开关按钮
    lazy var _aswitch: UISwitch = {
        let aswitch = UISwitch()
        aswitch.addTarget(self, action: #selector(switchTouched(sw:)), for: .valueChanged)
        
        return aswitch
    }()
    
    /// 详情标题
    var _detailLabel: UILabel?
    
    /// 右侧图片
    var _detailImageView: UIImageView?
    
    /// 数据源
    var viewModel: MeCenterViewModel! {
        willSet {
            
        }
    }
    
    // MARK: - Public Methods
    
    func setupChildViews() {
        
    }
    
    func setupSwitch() {
        
    }
    
    func switchTouched(sw: UISwitch) {
        
    }
}

