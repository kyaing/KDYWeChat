//
//  KDPersonInfoViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Photos

/// 个人信息界面
class KDPersonInfoViewController: UIViewController {

    lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor)
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
        
        let titleArray = [["头像", "昵称", "ID号"], ["性别", "地区"]]
        cell.textLabel?.text = titleArray[indexPath.section][indexPath.row]
        
        // 加载个人信息详情
        let currentUser = UserInfoManager.shareInstance.getCurrentUserInfo()
        let idString = currentUser?.objectId
        let nickname = currentUser?.nickname
        let gender   = currentUser?.gender
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.accessoryType = .None
                
                let avatorImageView = UIImageView(frame: CGRectMake(0, 0, 55, 55))
                avatorImageView.contentMode = .ScaleAspectFill
                avatorImageView.layer.masksToBounds = true
                
                if let imageURL = currentUser?.imageUrl {
                    avatorImageView.kf_setImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: kUserAvatarDefault), optionsInfo: nil)
                } else {
                    avatorImageView.image = UIImage(named: kUserAvatarDefault)
                }
                
                cell.accessoryView = avatorImageView
                
            } else if indexPath.row == 1 {
                cell.detailTextLabel?.text = nickname
            } else {
                cell.accessoryType  = .None
                cell.selectionStyle = .None
                cell.detailTextLabel?.text = idString
            }
        } else {
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = gender
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
            } else if row == 1 {  // 昵称
                self.ky_pushViewController(KDEditInfoViewController(title: "昵称"), animated: true)
            } else {              // ID号
                // 用户的唯一ID，用于查询用户，加好友等等
                // 可以复制，UIMenuItemController
                
            }
            
        } else {
            if row == 0 {         // 性别
                self.ky_pushViewController(KDEditInfoViewController(title: "性别"), animated: true)
            } else {              // 地区
                self.ky_pushViewController(KDEditInfoViewController(title: "地区"), animated: true)
            }
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
            // 相册中选择图片
            self.ky_presentImagePickerController(
                maxNumberOfSelections: 1,
                select: { (asset) in
                    
                }, deselect: { (asset) in
                    
                }, cancel: { (assets: [PHAsset]) in
                    
                }, finish: { [weak self] (assets: [PHAsset]) in
                    guard let strongSelf = self else { return }
                
                    // 点击完成后，获取图片并上传图片
                    if let image = assets[0].getUIImage() {
                        UserInfoManager.shareInstance.uploadUserAvatorInBackground(image, successs: { (success) in
                            print("上传头像成功")
                            
                            dispatch_async(dispatch_get_main_queue(), { 
                                strongSelf.infoTableView.reloadData()
                            })
                            
                        }, failures: { (error) in
                            print("上传头像失败：\(error.description)")
                        })
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
        configureCells(infoCell!, indexPath: indexPath)
        
        return infoCell!
    }
}

// MARK: - UITableViewDelegate
extension KDPersonInfoViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        configurePushController(indexPath)
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

