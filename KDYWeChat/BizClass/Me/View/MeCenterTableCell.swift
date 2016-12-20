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
    lazy var meTextLabel: UILabel = {
        let textlabel = UILabel()
        return textlabel
    }()
    
    /// 标题左侧图片
    lazy var meIamgeView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 右侧箭头
    lazy var meIndictor: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 开关按钮
    lazy var meSwitch: UISwitch = {
        let aswitch = UISwitch()
        aswitch.addTarget(self, action: #selector(switchTouched(sw:)), for: .valueChanged)
        
        return aswitch
    }()
    
    /// 详情标题
    lazy var meDetailLabel: UILabel = {
        let textlabel = UILabel()
        return textlabel
    }()
    
    /// 右侧图片
    lazy var meDetailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 数据源
    var viewModel: MeCenterViewModel! {
        willSet {
            
        }
    }
    
    // MARK: - Public Methods
    func setupChildViews() {
        
    }
    
    func setupSwitch() {
        self.contentView.addSubview(meSwitch)
        meSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
        }
    }
    
    func switchTouched(sw: UISwitch) {
        
    }
}

