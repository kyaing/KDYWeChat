//
//  KDMeViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/16.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

/// 我界面
class KDMeViewController: UITableViewController {
    
    @IBOutlet var meTableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.meTableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        self.meTableView.registerNib(UINib(nibName: "MeHeaderTableCell", bundle: nil), forCellReuseIdentifier: "MeHeaderTableCell")
    }
    
    // MARK: - UITableViewDataSoure
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let meHeaderCell = tableView.dequeueReusableCellWithIdentifier("MeHeaderTableCell", forIndexPath: indexPath) as! MeHeaderTableCell
            
            let user = AVUser.currentUser()
            let avatorFile = user.objectForKey("avatorImage") as? AVFile
            if avatorFile != nil {
                let imageData = avatorFile?.getData()
                let imageUrl = avatorFile?.url
                print("\(imageUrl, imageData)")
                
                meHeaderCell.avatorImageView.image = UIImage(data: imageData!)
            }
            
            return meHeaderCell
            
        } else {
            var baseCell = tableView.dequeueReusableCellWithIdentifier("baseCell")
            if baseCell == nil {
                baseCell = UITableViewCell(style: .Default, reuseIdentifier: "baseCell")
            }
            
            // 为什么在storyboard设置的没有显示出来？
            self.configureCells(baseCell!, indexPath: indexPath)
            
            return baseCell!
        }
    }
    
    func configureCells(baseCell: UITableViewCell, indexPath: NSIndexPath) {
        // 统一改变下字体大小
        baseCell.textLabel?.font = UIFont.systemFontOfSize(16)
        baseCell.accessoryType = .DisclosureIndicator
        baseCell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                baseCell.textLabel?.text = "相册"
                baseCell.imageView?.image = UIImage(named: "MoreMyAlbum")
            } else if indexPath.row == 1 {
                baseCell.textLabel?.text = "收藏"
                baseCell.imageView?.image = UIImage(named: "MoreMyFavorites")
            } else if indexPath.row == 2 {
                baseCell.textLabel?.text = "钱包"
                baseCell.imageView?.image = UIImage(named: "MoreMyBankCard")
            } else {
                baseCell.textLabel?.text = "卡包"
                baseCell.imageView?.image = UIImage(named: "MyCardPackageIcon")
            }
            
        } else if indexPath.section == 2 {
            baseCell.textLabel?.text = "表情"
            baseCell.imageView?.image = UIImage(named: "MoreExpressionShops")
            
        } else if indexPath.section == 3 {
            baseCell.textLabel?.text = "设置"
            baseCell.imageView?.image = UIImage(named: "MoreSetting")
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            self.ky_pushViewController(KDPersonInfoViewController(), animated: true)
            
        } else if indexPath.section == 3 {
            self.ky_pushViewController(KDSettingViewController(), animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 15
    }
}

