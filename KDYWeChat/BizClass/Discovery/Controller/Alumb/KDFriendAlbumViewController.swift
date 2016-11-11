//
//  KDFriendAlbumViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 朋友圈页面
class KDFriendAlbumViewController: UIViewController {

    lazy var albumTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.registerNib(UINib(nibName: "AlumbTableViewCell", bundle: nil), forCellReuseIdentifier: "AlumbTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = self.albumHeaderView
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    lazy var albumHeaderView: UIView = {
        let headerView = NSBundle.mainBundle().loadNibNamed("AlumbHeaderView", owner: self, options: nil).last as! AlumbHeaderView
        
        return headerView
    }()
    
    /// 数据源
    var albumDataSoruce: NSMutableArray!
    
    /// 用以获得高度的Cell
    var tempAlumbCell: AlumbTableViewCell?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "朋友圈"
         
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_Camera"), style: .Plain, target: self, action: #selector(self.publishAlumbAction))
        
        // 测试数据模拟
        testDataModels()
        
        self.albumTableView.reloadData()
        
        // 注册计算高度的Cell
        self.tempAlumbCell = self.albumTableView.dequeueReusableCellWithIdentifier("AlumbTableViewCell") as? AlumbTableViewCell
    }
    
    func testDataModels() {
        self.albumDataSoruce = NSMutableArray()
        
        let model1 = AlumbModel(url: "", nickname: "kaideyi", time: "2016-11-11", text: "测理就是UITextView内容改变的时候")
        let model2 = AlumbModel(url: "", nickname: "张三", time: "2015-3", text: "计算自身高度，然后通知UITableView更新，这样就会触发UITableViewCell高度重新计算测试")
        let model3 = AlumbModel(url: "", nickname: "李四", time: "12:09", text: "这样就会触发UITableViewCell高度重新计算，以达到wCe这样就U有阴，有ITableVie有阴，有wCe这样就会触有阴，有发UITableViewCe这样就会触发UITableViewCe阴，有阴，有点冷")
        let model4 = AlumbModel(url: "", nickname: "王五", time: "2016-11-1", text: "1234567098765432")
        let model5 = AlumbModel(url: "", nickname: "赵六", time: "2016-11", text: "测试测试")
        let model6 = AlumbModel(url: "", nickname: "大黄", time: "9:30", text: "Snapkit+Autolayout动态计算高度")
        
        self.albumDataSoruce.addObject(model1)
        self.albumDataSoruce.addObject(model2)
        self.albumDataSoruce.addObject(model3)
        self.albumDataSoruce.addObject(model4)
        self.albumDataSoruce.addObject(model5)
        self.albumDataSoruce.addObject(model6)
    }
    
    // MARK: - Event Response 
    func publishAlumbAction() {
        
    }
}

// MARK: - UITableViewDataSource
extension KDFriendAlbumViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumDataSoruce.count > 0 ? self.albumDataSoruce.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlumbTableViewCell", forIndexPath: indexPath) as! AlumbTableViewCell
        cell.selectionStyle = .None
        
        // 设置Cell的内容
        let model = self.albumDataSoruce.objectAtIndex(indexPath.row) as! AlumbModel
        cell.setupCellContents(model)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KDFriendAlbumViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let cell = self.tempAlumbCell {
            // 以Model的内容来计算高度
            let model = self.albumDataSoruce.objectAtIndex(indexPath.row) as! AlumbModel
            cell.setupCellContents(model)
            
            let height = cell.getCellHeight()
            return height
        }
        
        return 0
    }
}

