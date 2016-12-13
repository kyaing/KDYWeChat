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
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor.rawValue)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.darkGray
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
    func configureCells(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        
        cell.accessoryType  = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        let titleArray = [["头像", "昵称", "ID号"], ["性别", "地区"]]
        cell.textLabel?.text = titleArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        // 加载个人信息详情
        let currentUser = UserInfoManager.shareInstance.getCurrentUserInfo()
        let idString = currentUser?.objectId
        let nickname = currentUser?.nickname
        let gender   = currentUser?.gender
        
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                cell.accessoryType = .none
                
                let avatorImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
                avatorImageView.contentMode = .scaleAspectFill
                avatorImageView.layer.masksToBounds = true
                
                if let imageURL = currentUser?.imageUrl {
                    avatorImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: kUserAvatarDefault), options: nil)
                } else {
                    avatorImageView.image = UIImage(named: kUserAvatarDefault)
                }
                
                cell.accessoryView = avatorImageView
                
            } else if (indexPath as NSIndexPath).row == 1 {
                cell.detailTextLabel?.text = nickname
            } else {
                cell.accessoryType  = .none
                cell.selectionStyle = .none
                cell.detailTextLabel?.text = idString
            }
        } else {
            if (indexPath as NSIndexPath).row == 0 {
                cell.detailTextLabel?.text = gender
            } else {
                cell.detailTextLabel?.text = "北京"
            }
        }
    }
    
    func configurePushController(_ indexPath: IndexPath) {
        let section = (indexPath as NSIndexPath).section
        let row = (indexPath as NSIndexPath).row
        
        if section == 0 {
            if row == 0 {   // 头像
                setupPickerAlertController()
            } else if row == 1 {  // 昵称
                // 取得对应的 Cell
                let cell = self.infoTableView.cellForRow(at: indexPath)
                
                let editController = KDEditInfoViewController(title: "昵称")
                editController.editInfoStr = cell?.detailTextLabel?.text
                
                editController.editDoneClosure = { textString in
                    cell?.detailTextLabel?.text = textString
                    
                    // 上传用户昵称
                    UserInfoManager.shareInstance.uploadUserNicknameInBackground(
                        textString,
                        successs: { (success) in
                            print("上传昵称成功")
                            
                        }, failures: { (error) in
                            print("上传昵称失败，error = \(error.localizedDescription)")
                        })
                }
                
                ky_pushViewController(editController, animated: true)
            } else {   // ID号
                // 用户的唯一ID，用于查询用户，加好友等等
                // 可以复制，UIMenuItemController
            }
            
        } else {
            if row == 0 {   // 性别
                ky_pushViewController(KDEditInfoViewController(title: "性别"), animated: true)
            } else {    // 地区
                ky_pushViewController(KDEditInfoViewController(title: "地区"), animated: true)
            }
        }
    }
    
    /**
     *  图片和拍照选择器
     */
    func setupPickerAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { (alertAction) in
        }
        
        let photoAction = UIAlertAction(title: "从手机相册选择", style: .default) { (alertAction) in
            // 相册中选择图片
            self.ky_presentImagePickerController(
                1,
                select: { (asset) in
                    
                }, deselect: { (asset) in
                    
                }, cancel: { (assets: [PHAsset]) in
                    
                }, finish: { [weak self] (assets: [PHAsset]) in
                    guard let strongSelf = self else { return }
                
                    // 点击完成后，获取图片并上传图片
                    if let image = assets[0].getUIImage() {
                        UserInfoManager.shareInstance.uploadUserAvatorInBackground(image, successs: { (success) in
                            print("上传头像成功")
                            
                            DispatchQueue.main.async(execute: { 
                                strongSelf.infoTableView.reloadData()
                            })
                            
                        }, failures: { (error) in
                            print("上传头像失败：\(error.localizedDescription)")
                        })
                    }
    
            }) {
                print("completion")
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        cameraAction.setValue(UIColor(colorHex: "#2a2a2a"), forKey: "_titleTextColor")
        photoAction.setValue(UIColor(colorHex: "#2a2a2a"), forKey: "_titleTextColor")
        cancelAction.setValue(UIColor(colorHex: "#7d7d7d"), forKey: "_titleTextColor")
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension KDPersonInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell")
        if infoCell == nil {
            infoCell = UITableViewCell(style: .value1, reuseIdentifier: "infoCell")
        }
        configureCells(infoCell!, indexPath: indexPath)
        
        return infoCell!
    }
}

// MARK: - UITableViewDelegate
extension KDPersonInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        configurePushController(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                return 70
            }
        }
        
        return 44
    }
}

