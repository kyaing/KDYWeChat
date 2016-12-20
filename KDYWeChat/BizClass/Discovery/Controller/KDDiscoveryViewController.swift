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
        
        tableView.backgroundColor = KDYColor.TableBackground.color
        tableView.separatorColor  = KDYColor.Separator.color
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableViewDataSoure
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "discoveryCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "discoveryCell")
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            cell?.accessoryType = .disclosureIndicator
        }
        
        configCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func configCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.textLabel?.text = "朋友圈"
            cell.imageView?.image = UIImage(named: "ff_IconShowAlbum")
        } else if (indexPath as NSIndexPath).section == 1 {
            cell.textLabel?.text = "扫一扫"
            cell.imageView?.image = UIImage(named: "ff_IconQRCode")
        } else {
            cell.textLabel?.text = "我直播"
            cell.imageView?.image = UIImage(named: "ff_IconLocationService")
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 0 {
            ky_pushViewController(KDFriendAlbumViewController(), animated: true)
            
        } else if (indexPath as NSIndexPath).section == 1 {
            ky_pushViewController(KDQRCodeViewController(), animated: true)
            
        } else {
            ky_pushViewController(KDMyLiveViewController(), animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

