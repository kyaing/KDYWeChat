//
//  KDSettingViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

class KDSettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
    }
    
    // MARK: - UITableViewDataSoure
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("settingCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "settingCell")
            cell!.accessoryType = .DisclosureIndicator
            cell!.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
        
        self.configCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func configCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        // 统一改变下字体大小
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "账号和安全"
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "新消息通知"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "隐私"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "通用"
            }
        } else {
            cell.textLabel?.text = "退出登录"
            
            cell.accessoryType = .None
            cell.textLabel?.textAlignment = .Center
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
        } else {  // 退出登录
            self.setupAlertController()
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    // MARK: - Private Method 
    func setupAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let logoutAction = UIAlertAction(title: "退出登录", style: .Destructive) { alertAction in
            self.logoutCurrentUserAction()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        logoutAction.setValue(UIColor(rgba: "#2a2a2a"), forKey: "_titleTextColor")
        cancelAction.setValue(UIColor(rgba: "#7d7d7d"), forKey: "_titleTextColor")
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Event Response
    func logoutCurrentUserAction() {
        EMClient.sharedClient().logout(true) { error in
            if error != nil {
                print(">>> 环信退出失败，error = \(error.description) <<<")
                
            } else {
                AVUser.logOut()
                NSNotificationCenter.defaultCenter().postNotificationName(kLoginStateChangedNoti, object: NSNumber(bool: false))
            }
        }
    }
}

