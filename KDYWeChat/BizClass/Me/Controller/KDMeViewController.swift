//
//  KDMeViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/16.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 我界面
class KDMeViewController: UITableViewController {
    
    @IBOutlet var meTableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.meTableView.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        self.meTableView.separatorColor  = UIColor(colorHex: .separatorColor)
        self.meTableView.registerReusableCell(MeHeaderTableCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.meTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSoure
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let headerCell: MeHeaderTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            
            if let currentUser = UserInfoManager.shareInstance.getCurrentUserInfo() {
                headerCell.usernameLabel.text = currentUser.username
                
                if let nickname = currentUser.nickname {
                    headerCell.useridLabel.text = "昵称：" + nickname
                } else {
                    headerCell.useridLabel.text = "ID：" + (currentUser.objectId)!
                }
                
                if let imageURL = currentUser.imageUrl {
                    headerCell.avatorImageView.kf_setImageWithURL(URL(string: imageURL), placeholderImage: UIImage(named: kUserAvatarDefault))
                }
            }
            
            return headerCell
            
        } else {
            var baseCell = tableView.dequeueReusableCell(withIdentifier: "baseCell")
            if baseCell == nil {
                baseCell = UITableViewCell(style: .default, reuseIdentifier: "baseCell")
            }
            
            // 为什么在storyboard设置的没有显示出来？
            self.configureCells(baseCell!, indexPath: indexPath)
            
            return baseCell!
        }
    }
    
    func configureCells(_ baseCell: UITableViewCell, indexPath: IndexPath) {
        // 统一改变下字体大小
        baseCell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        baseCell.accessoryType = .disclosureIndicator
        baseCell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        if (indexPath as NSIndexPath).section == 1 {
            if (indexPath as NSIndexPath).row == 0 {
                baseCell.textLabel?.text = "相册"
                baseCell.imageView?.image = UIImage(named: "MoreMyAlbum")
            } else if (indexPath as NSIndexPath).row == 1 {
                baseCell.textLabel?.text = "收藏"
                baseCell.imageView?.image = UIImage(named: "MoreMyFavorites")
            } else if (indexPath as NSIndexPath).row == 2 {
                baseCell.textLabel?.text = "钱包"
                baseCell.imageView?.image = UIImage(named: "MoreMyBankCard")
            } else {
                baseCell.textLabel?.text = "卡包"
                baseCell.imageView?.image = UIImage(named: "MyCardPackageIcon")
            }
            
        } else if (indexPath as NSIndexPath).section == 2 {
            baseCell.textLabel?.text = "表情"
            baseCell.imageView?.image = UIImage(named: "MoreExpressionShops")
            
        } else if (indexPath as NSIndexPath).section == 3 {
            baseCell.textLabel?.text = "设置"
            baseCell.imageView?.image = UIImage(named: "MoreSetting")
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 0 {
            ky_pushViewController(KDPersonInfoViewController(), animated: true)
            
        } else if (indexPath as NSIndexPath).section == 3 {
            ky_pushViewController(KDSettingViewController(), animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 15
    }
}

