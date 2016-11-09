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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "朋友圈"
        self.albumTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension KDFriendAlbumViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("albumCell")
        if cell == nil {
            cell = AlumbTableViewCell(style: .Default, reuseIdentifier: "albumCell")
        }
        
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension KDFriendAlbumViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 15+25+10+100+15+10+10
    }
}

