//
//  KDContactsViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud
import SnapKit
import MBProgressHUD
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/// 通讯录页面
final class KDContactsViewController: UIViewController {

    // MARK: - Parameters
    var contactsDataSource: NSMutableArray = []
    var sectionsArray: NSMutableArray      = []
    var sectionTitlesArray: NSMutableArray = []
    
    /// _User表中，登录用户的好友 (AVUser)
    var frindsArray: [AnyObject] = []
    
    var collation: UILocalizedIndexedCollation!
    
    /// 搜索控制器
    lazy var searchController: UISearchController = {
        let searchController: UISearchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor(colorHex: KDYColor.chatGreenColor.rawValue)
        searchController.searchBar.sizeToFit()
        
        return searchController
    }()
    
    lazy var contactsTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor.rawValue)
        tableView.register(cellType: ContactsTableCell.self)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(colorHex: KDYColor.separatorColor.rawValue)
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.darkGray
        tableView.tableHeaderView = self.searchController.searchBar
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    lazy var rightBarItem: UIBarButtonItem = {
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_addfriends"), style: .plain, target: self, action: #selector(self.addFrinedAction))
        
        return rightBarItem
    }()
    
    lazy var tableFooterLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        
        reloadFriendsDataArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Public Methods
    
    /**
     *  获取好友列表
     */
    func reloadFriendsDataArray() {
        let friendsNames = EMClient.shared().contactManager.getContactsFromServerWithError(nil)
        print("friendsName = \(friendsNames)")
        
        // 从leanClond 加载好友列表
        loadFrinedsFromLeanCloudWithBuddy(friendsNames as! [String])
    }
    
    /**
     *  配置分组的内容
     */
    func configureSections(_ dataArray: NSMutableArray) {
        self.collation = UILocalizedIndexedCollation.current()
        self.sectionTitlesArray = NSMutableArray(array: collation.sectionTitles)
        
        let index = self.collation.sectionTitles.count
        let sectionTitlesCount = index
        
        let newSectionArray = NSMutableArray(capacity: sectionTitlesCount)
        
        for _ in 0...index {
            let array = NSMutableArray()
            newSectionArray.add(array)
        }
        
        for contact in contactsDataSource {
            let sectionNumber = collation.section(for: contact, collationStringSelector: #selector(getter: AVUser.username))
            let sectionObjs = newSectionArray.object(at: sectionNumber)
            (sectionObjs as AnyObject).add(contact)
        }
        
        for _ in 0...index {
            let userObjsArrayForSection = newSectionArray.object(at: index)
            
            let sortedUserObjsArrayForSection = collation.sortedArray(from: userObjsArrayForSection as! [AnyObject], collationStringSelector: #selector(getter: AVUser.username))
            newSectionArray.replaceObject(at: index, with: sortedUserObjsArrayForSection)
        }
        
        sectionsArray = newSectionArray
    }
    
    /**
     *  配置Cell内容
     */
    func configureCells(_ cell: ContactsTableCell, indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                cell.usernameLabel.text = "新的朋友"
                cell.avatorImage.image = UIImage(named: "plugins_FriendNotify")
                
            } else if (indexPath as NSIndexPath).row == 1 {
                cell.usernameLabel.text = "群聊"
                cell.avatorImage.image = UIImage(named: "add_friend_icon_addgroup")
                
            } else {
                cell.usernameLabel.text = "公众号"
                cell.avatorImage.image = UIImage(named: "add_friend_icon_offical")
            }
            
        } else {
            let userNameInSection = self.sectionsArray.object(at: (indexPath as NSIndexPath).section)
            let model = (userNameInSection as AnyObject).object(at: (indexPath as NSIndexPath).row) as! ContactModel
            
            let userInfo = UserInfoManager.shareInstance.getUserInfoByName(model.username!)
            cell.usernameLabel.text = userInfo?.username
            if let imageURL = userInfo?.imageUrl {
                cell.avatorImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "user_avatar"))
            }
        }
    }
    
    /**
     *  配置进入下一个的界面
     */
    func configurePushController(_ indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                let newfriendController = KDNewFriendsViewController.initFromNib()
                ky_pushViewController(newfriendController, animated: true)
                
            } else if (indexPath as NSIndexPath).row == 1 {
                
            } else {
                
            }
            
        } else {
            let userNameInSection = self.sectionsArray.object(at: (indexPath as NSIndexPath).section)
            let contactModel = (userNameInSection as AnyObject).object(at: (indexPath as NSIndexPath).row) as! ContactModel
            if contactModel.username == AVUser.current().username { return }
            
            let detailController = KDPersonalDetailViewController(model: nil)
            detailController.contactModel = contactModel
            
            ky_pushViewController(detailController, animated: true)
        }
    }
    
    /**
     *  加载在LeanClond 的好友
     */
    func loadFrinedsFromLeanCloudWithBuddy(_ frinedNames: [String]) {
        
        // 查询 _User表里的用户 (这里的查询效率会低点)
        let userQuery = AVQuery(className: "_User")
        var frindsArray: [AnyObject] = []
    
        MBProgressHUD.showAdded(to: self.view, animated: true)
        userQuery?.findObjectsInBackground { (objects, error) in
            
            if objects == nil { return }
            for object in objects as! [AVUser] {
                let dic = object.dictionaryForObject()
                let username = dic?.object(forKey: "username") as! String
                
                let index = frinedNames.count
                for i in 0..<index {
                    if username == frinedNames[i] {
                        frindsArray.append(object)
                    }
                }
            }
            
            self.contactsDataSource.removeAllObjects()
            
            for friend in frindsArray as! [AVUser] {
                let model = ContactModel()
                model.username = friend.username
                model.avatorURL = (friend.object(forKey: "avatorImage") as? AVFile)?.url
                
                self.contactsDataSource.add(model)
            }
            
            let userModel = ContactModel()
            let currentName = EMClient.shared().currentUsername
            userModel.username = currentName
            self.contactsDataSource.add(userModel)
            
            DispatchQueue.main.async(execute: {
                // 配置分组
                self.configureSections(self.contactsDataSource)
                
                self.tableFooterLabel.text = String("\(frindsArray.count+1)位联系人")
                self.contactsTableView.tableFooterView = self.tableFooterLabel

                LoadingHUDShow.shareInstance.hideHUD(self.view)
                self.contactsTableView.reloadData()
                
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
    
    
    // MARK: - Event Response 
    func addFrinedAction() {
        let controller = KDAddFriendViewController.initFromNib()
        ky_pushViewController(controller, animated: true)
    }
    
    /**
     *  处理好友申请操作
     */
    func handleFrinedRequest() {
        
    }
}

// MARK: - UISearchResultsUpdating
extension KDContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

// MARK: - UISearchControllerDelegate
extension KDContactsViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

// MARK: - UITableViewDataSource
extension KDContactsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return collation.sectionTitles.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return (sectionsArray[section] as AnyObject).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactsCell: ContactsTableCell = tableView.dequeueReusableCell(for: indexPath)
        
        // 设置Cell的数据
        configureCells(contactsCell, indexPath: indexPath)
        
        return contactsCell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 14)
        headerView.textLabel?.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        let objsInSection = sectionsArray[section]
        guard (objsInSection as AnyObject).count > 0 else { return nil }
        
        return self.collation.sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.collation.sectionIndexTitles
    }
}

// MARK: - UITableViewDelegate
extension KDContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        configurePushController(indexPath)
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 添加备注按钮
        let noteRowAction = UITableViewRowAction(style: .normal, title: "备注") { (rowAction, indexPath) in
            print(">>> 备注好友 <<<")
        }
        
        return [noteRowAction]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let objsInSection = sectionsArray[section]
        guard (objsInSection as AnyObject).count > 0 else { return 0 }
        
        return 20
    }
}

