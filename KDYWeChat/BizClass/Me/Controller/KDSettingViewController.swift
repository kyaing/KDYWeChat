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
        tableView.backgroundColor = KDYColor.TableBackground.color
        tableView.separatorColor  = KDYColor.Separator.color
    }
    
    // MARK: - UITableViewDataSoure
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "settingCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "settingCell")
            cell!.accessoryType = .disclosureIndicator
            cell!.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
        
        self.configCell(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func configCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.textLabel?.text = "账号和安全"
        } else if (indexPath as NSIndexPath).section == 1 {
            if (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = "新消息通知"
            } else if (indexPath as NSIndexPath).row == 1 {
                cell.textLabel?.text = "隐私"
            } else if (indexPath as NSIndexPath).row == 2 {
                cell.textLabel?.text = "通用"
            }
        } else {
            cell.textLabel?.text = "退出登录"
            
            cell.accessoryType = .none
            cell.textLabel?.textAlignment = .center
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 0 {
            
        } else if (indexPath as NSIndexPath).section == 1 {
            
        } else {  // 退出登录
            setupAlertController()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    // MARK: - Private Method 
    func setupAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "退出登录", style: .destructive) { alertAction in
            self.logoutCurrentUserAction()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        logoutAction.setValue(UIColor(colorHex: "#2a2a2a"), forKey: "_titleTextColor")
        cancelAction.setValue(UIColor(colorHex: "#7d7d7d"), forKey: "_titleTextColor")
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Event Response
    func logoutCurrentUserAction() {
        EMClient.shared().logout(true) { error in
            if error != nil {
                print(">>> 环信退出失败，error = \(error?.description) <<<")
                
            } else {
                AVUser.logOut()  // 退出LeanCloud
                NotificationCenter.default.post(name: Notification.Name(rawValue: kLoginStateChangedNoti), object: NSNumber(value: false as Bool))
            }
        }
    }
}

