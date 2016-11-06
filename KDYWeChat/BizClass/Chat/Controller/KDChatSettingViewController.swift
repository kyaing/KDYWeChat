//
//  KDChatSettingViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/11/5.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Photos

/// 聊天设置页面
class KDChatSettingViewController: UIViewController {

    lazy var settingTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.sectionIndexColor = UIColor.darkGrayColor()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    var conversationId: String!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "聊天详情"
        self.settingTableView.reloadData()
    }
    
    func configurePushController(indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                setupPickerAlertController()
            }
        }
    }
    
    func setupPickerAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .Default) { (alertAction) in
        }
        
        let photoAction = UIAlertAction(title: "从手机相册选择", style: .Default) { (alertAction) in
            
            // 相册中选择图片，做为聊天背景
            self.ky_presentImagePickerController(
                maxNumberOfSelections: 1,
                select: { (asset) in
                    
                }, deselect: { (asset) in
                    
                }, cancel: { (assets: [PHAsset]) in
                    
                }, finish: { (assets: [PHAsset]) in
    
                    if let image = assets[0].getUIImage() {
                        let imageData = NSKeyedArchiver.archivedDataWithRootObject(image)
                        
                        // 暂且先把图片，存储到本地
                        NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: self.conversationId)
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
            }) {
                print("completion")
            }
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
extension KDChatSettingViewController:  UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell")
        if settingCell == nil {
            settingCell = UITableViewCell(style: .Value1, reuseIdentifier: "settingCell")
            settingCell?.accessoryType = .DisclosureIndicator
        }
        
        configureCells(settingCell!, indexPath: indexPath)
        
        return settingCell!
    }
    
    func configureCells(cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        
        if indexPath.section == 0 {
            cell.accessoryType = .None
            
        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = "设置聊天背景"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "查找聊天内容"
            } else {
                cell.textLabel?.text = "清空聊天记录"
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension KDChatSettingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        configurePushController(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

