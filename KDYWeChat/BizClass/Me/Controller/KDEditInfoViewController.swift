//
//  KDEditInfoViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 编辑个人信息界面
class KDEditInfoViewController: UIViewController {

    lazy var eidtinfoTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
}

