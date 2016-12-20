//
//  MeCenterViewModel.swift
//  KDYWeChat
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

/// 指示器类型(可扩展)
enum MeAccessoryType {
    case None
    case Image
    case Switch
    case View
    case Indicator
}

class MeCenterViewModel: NSObject {

    typealias clickCellBlock = () -> Void
    typealias switchValueBlock = (_ isOn: Bool) -> Void
    
    var textString: String?
    var image: UIImage?
    var detailString: String?
    var detailImage: UIImage?
    var accessoryType: MeAccessoryType?
    
    var clickBlock: clickCellBlock?
    var switchBlock: switchValueBlock?
}

