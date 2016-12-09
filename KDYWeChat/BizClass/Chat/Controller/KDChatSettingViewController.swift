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
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.darkGray
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
    
    func configurePushController(_ indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            if (indexPath as NSIndexPath).row == 0 {
                setupPickerAlertController()
            }
        }
    }
    
    func setupPickerAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { (alertAction) in
        }
        
        let photoAction = UIAlertAction(title: "从手机相册选择", style: .default) { (alertAction) in
            
            // 相册中选择图片，做为聊天背景
            self.ky_presentImagePickerController(
                maxNumberOfSelections: 1,
                select: { (asset) in
                    
                }, deselect: { (asset) in
                    
                }, cancel: { (assets: [PHAsset]) in
                    
                }, finish: { (assets: [PHAsset]) in
    
                    if let image = assets[0].getUIImage() {
                        let imageData = NSKeyedArchiver.archivedData(withRootObject: image)
                        
                        // 暂且先把图片，存储到本地
                        UserDefaults.standard.set(imageData, forKey: self.conversationId)
                        UserDefaults.standard.synchronize()
                    }
            }) {
                print("completion")
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cameraAction.setValue(UIColor(rgba: "#2a2a2a"), forKey: "_titleTextColor")
        photoAction.setValue(UIColor(rgba: "#2a2a2a"), forKey: "_titleTextColor")
        cancelAction.setValue(UIColor(rgba: "#7d7d7d"), forKey: "_titleTextColor")
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension KDChatSettingViewController:  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell")
        if settingCell == nil {
            settingCell = UITableViewCell(style: .value1, reuseIdentifier: "settingCell")
            settingCell?.accessoryType = .disclosureIndicator
        }
        
        configureCells(settingCell!, indexPath: indexPath)
        
        return settingCell!
    }
    
    func configureCells(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.accessoryType = .none
            
        } else {
            if (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = "设置聊天背景"
            } else if (indexPath as NSIndexPath).row == 1 {
                cell.textLabel?.text = "查找聊天内容"
            } else {
                cell.textLabel?.text = "清空聊天记录"
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension KDChatSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        configurePushController(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 70
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

