//
//  KDPersonInfoViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 个人信息界面
class KDPersonInfoViewController: UIViewController {

    lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.sectionIndexColor = UIColor.darkGrayColor()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人信息"
        self.infoTableView.reloadData()
    }
    
    // MARK: - Private Methods
    func configureCells(cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(16)
        
        cell.accessoryType   = .DisclosureIndicator
        cell.separatorInset  = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        let titleArray = [["头像", "名字", "微信号"], ["性别", "地区"]]
        cell.textLabel?.text = titleArray[indexPath.section][indexPath.row]
        
        // 加载个人信息详情
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.accessoryType = .None
                
                let avatorImageView = UIImageView(frame: CGRectMake(0, 0, 55, 55))
                avatorImageView.image = UIImage(named: "user_avatar")
                cell.accessoryView = avatorImageView
            } else if indexPath.row == 1 {
                cell.detailTextLabel?.text = "kaideyi"
            } else {
                cell.detailTextLabel?.text = "kaideyi"
            }
        } else {
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = "男"
            } else {
                cell.detailTextLabel?.text = "北京"
            }
        }
    }
    
    func configurePushController(indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {         // 头像
                self.setupPickerAlertController()
            } else if row == 1 {  // 名字
                self.ky_pushViewController(KDEditInfoViewController(), animated: true)
            }
            
        } else {
            self.ky_pushViewController(KDEditInfoViewController(), animated: true)
        }
    }
    
    /**
     *  图片、拍照选择器
     */
    func setupPickerAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .Default) { (alertAction) in
            
        }
        
        let photoAction = UIAlertAction(title: "从手机相册选择", style: .Default) { (alertAction) in
            // 选择图片
            AuthorityManager.shareInstance.choosePhotos({ (imagePicker) in
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
            }, alertAction: { (resource) in
                self.alertNoPermissionToAccess(resource)
            })
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        cameraAction.setValue(UIColor(rgba: "#2a2a2a"), forKey: "_titleTextColor")
        photoAction.setValue(UIColor(rgba: "#2a2a2a"), forKey: "_titleTextColor")
        cancelAction.setValue(UIColor(rgba: "#7d7d7d"), forKey: "_titleTextColor")
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension KDPersonInfoViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var infoCell = tableView.dequeueReusableCellWithIdentifier("infoCell")
        if infoCell == nil {
            infoCell = UITableViewCell(style: .Value1, reuseIdentifier: "infoCell")
        }
        self.configureCells(infoCell!, indexPath: indexPath)
        
        return infoCell!
    }
}

// MARK: - UITableViewDelegate
extension KDPersonInfoViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        self.configurePushController(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 70
            }
        }
        
        return 44
    }
}

