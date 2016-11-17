//
//  KDDiscoveryViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 发现界面
final class KDDiscoveryViewController: UITableViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        tableView.separatorColor  = UIColor(colorHex: .separatorColor)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableViewDataSoure
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("discoveryCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "discoveryCell")
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            cell?.accessoryType = .DisclosureIndicator
        }
        
        configCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func configCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "朋友圈"
            cell.imageView?.image = UIImage(named: "ff_IconShowAlbum")
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "扫一扫"
            cell.imageView?.image = UIImage(named: "ff_IconQRCode")
        } else {
            cell.textLabel?.text = "我直播"
            cell.imageView?.image = UIImage(named: "ff_IconLocationService")
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            ky_pushViewController(KDFriendAlbumViewController(), animated: true)
            
        } else if indexPath.section == 1 {
            ky_pushViewController(KDQRCodeViewController(), animated: true)
            
        } else {
            ky_pushViewController(KDMyLiveViewController(), animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

