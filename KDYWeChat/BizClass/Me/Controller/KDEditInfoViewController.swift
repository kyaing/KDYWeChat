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
        tableView.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    var titleStr: String?
    
    // MARK: - Life Cycle
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleStr = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = self.titleStr
    }
}

