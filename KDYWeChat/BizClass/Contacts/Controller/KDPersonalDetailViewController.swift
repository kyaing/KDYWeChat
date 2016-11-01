//
//  KDPersonalDetailViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 个人(他人)详情页面
class KDPersonalDetailViewController: UIViewController {

    var model: ChatModel!
    
    // MARK: - Life Cycle
    init(model: ChatModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "详情资料"
        self.view.backgroundColor = UIColor.whiteColor()
        
        if self.model.fromMe! {
            print("点击自己的头像")
        } else {  // 其它用户
            print("点击他人的头像")
        }
    }
}

