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
        searchController.searchBar.tintColor = UIColor(colorHex: .chatGreenColor)
        searchController.searchBar.sizeToFit()
        
        return searchController
    }()
    
    lazy var contactsTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        tableView.registerReusableCell(ContactsTableCell)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(colorHex: .separatorColor)
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.sectionIndexColor = UIColor.darkGrayColor()
        tableView.tableHeaderView = self.searchController.searchBar
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    lazy var rightBarItem: UIBarButtonItem = {
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_addfriends"), style: .Plain, target: self, action: #selector(self.addFrinedAction))
        
        return rightBarItem
    }()
    
    lazy var tableFooterLabel: UILabel = {
        let label = UILabel(frame: CGRectMake(0, 0, 0, 44))
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Center
        
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        
        reloadFriendsDataArray()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Public Methods
    
    /**
     *  获取好友列表
     */
    func reloadFriendsDataArray() {
        let friendsNames = EMClient.sharedClient().contactManager.getContactsFromServerWithError(nil)
        print("friendsName = \(friendsNames)")
        
        // 从leanClond 加载好友列表
        loadFrinedsFromLeanCloudWithBuddy(friendsNames as! [String])
    }
    
    /**
     *  配置分组的内容
     */
    func configureSections(dataArray: NSMutableArray) {
        self.collation = UILocalizedIndexedCollation.currentCollation()
        self.sectionTitlesArray = NSMutableArray(array: collation.sectionTitles)
        
        let index = self.collation.sectionTitles.count
        let sectionTitlesCount = index
        
        let newSectionArray = NSMutableArray(capacity: sectionTitlesCount)
        
        for _ in 0...index {
            let array = NSMutableArray()
            newSectionArray.addObject(array)
        }
        
        for contact in contactsDataSource {
            let sectionNumber = collation.sectionForObject(contact, collationStringSelector: Selector("username"))
            let sectionObjs = newSectionArray.objectAtIndex(sectionNumber)
            sectionObjs.addObject(contact)
        }
        
        for _ in 0...index {
            let userObjsArrayForSection = newSectionArray.objectAtIndex(index)
            
            let sortedUserObjsArrayForSection = collation.sortedArrayFromArray(userObjsArrayForSection as! [AnyObject], collationStringSelector: Selector("username"))
            newSectionArray.replaceObjectAtIndex(index, withObject: sortedUserObjsArrayForSection)
        }
        
        self.sectionsArray = newSectionArray
    }
    
    /**
     *  配置Cell内容
     */
    func configureCells(cell: ContactsTableCell, indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.usernameLabel.text = "新的朋友"
                cell.avatorImage.image = UIImage(named: "plugins_FriendNotify")
                
            } else if indexPath.row == 1 {
                cell.usernameLabel.text = "群聊"
                cell.avatorImage.image = UIImage(named: "add_friend_icon_addgroup")
                
            } else {
                cell.usernameLabel.text = "公众号"
                cell.avatorImage.image = UIImage(named: "add_friend_icon_offical")
            }
            
        } else {
            let userNameInSection = self.sectionsArray.objectAtIndex(indexPath.section)
            let model = userNameInSection.objectAtIndex(indexPath.row) as! ContactModel
            
            let userInfo = UserInfoManager.shareInstance.getUserInfoByName(model.username!)
            cell.usernameLabel.text = userInfo?.username
            if let imageURL = userInfo?.imageUrl {
                cell.avatorImage.kf_setImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: "user_avatar"), optionsInfo: nil)
            }
        }
    }
    
    /**
     *  配置进入下一个的界面
     */
    func configurePushController(indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let newfriendController = KDNewFriendsViewController(nibName: "KDNewFriendsViewController", bundle: nil)
                ky_pushViewController(newfriendController, animated: true)
                
            } else if indexPath.row == 1 {
                
            } else {
                
            }
            
        } else {
            let userNameInSection = self.sectionsArray.objectAtIndex(indexPath.section)
            let contactModel = userNameInSection.objectAtIndex(indexPath.row) as! ContactModel
            if contactModel.username == AVUser.currentUser().username { return }
            
            let detailController = KDPersonalDetailViewController(model: nil)
            detailController.contactModel = contactModel
            
            ky_pushViewController(detailController, animated: true)
        }
    }
    
    /**
     *  加载在LeanClond 的好友
     */
    func loadFrinedsFromLeanCloudWithBuddy(frinedNames: [String]) {
        
        // 查询 _User表里的用户 (这里的查询效率会低点)
        let userQuery = AVQuery(className: "_User")
        var frindsArray: [AnyObject] = []
        
        LoadingHUDShow.shareInstance.showHUDWithText("加载中...", toView: self.view)
        userQuery.findObjectsInBackgroundWithBlock { (objects, error) in
            
            for object in objects as! [AVUser] {
                let dic = object.dictionaryForObject()
                let username = dic.objectForKey("username") as! String
                
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
                model.avatorURL = (friend.objectForKey("avatorImage") as? AVFile)?.url
                
                self.contactsDataSource.addObject(model)
            }
            
            let userModel = ContactModel()
            let currentName = EMClient.sharedClient().currentUsername
            userModel.username = currentName
            self.contactsDataSource.addObject(userModel)
            
            dispatch_async(dispatch_get_main_queue(), {
                // 配置分组
                self.configureSections(self.contactsDataSource)
                
                self.tableFooterLabel.text = String("\(frindsArray.count+1)位联系人")
                self.contactsTableView.tableFooterView = self.tableFooterLabel

                LoadingHUDShow.shareInstance.hideHUD(self.view)
                self.contactsTableView.reloadData()
            })
        }
    }
    
    
    // MARK: - Event Response 
    func addFrinedAction() {
        
    }
    
    /**
     *  处理好友申请操作
     */
    func handleFrinedRequest() {
        
    }
}

// MARK: - UISearchResultsUpdating
extension KDContactsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
}

// MARK: - UISearchControllerDelegate
extension KDContactsViewController: UISearchControllerDelegate {
    func willPresentSearchController(searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
}

// MARK: - UITableViewDataSource
extension KDContactsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.collation.sectionTitles.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return sectionsArray[section].count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contactsCell: ContactsTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
        
        // 设置Cell的数据
        configureCells(contactsCell, indexPath: indexPath)
        
        return contactsCell
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        
        headerView.textLabel?.font = UIFont.systemFontOfSize(14)
        headerView.textLabel?.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        let objsInSection = sectionsArray[section]
        guard objsInSection.count > 0 else { return nil }
        
        return self.collation.sectionTitles[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.collation.sectionIndexTitles
    }
}

// MARK: - UITableViewDelegate
extension KDContactsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        configurePushController(indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // 添加备注按钮
        let noteRowAction = UITableViewRowAction(style: .Normal, title: "备注") { (rowAction, indexPath) in
            print(">>> 备注好友 <<<")
        }
        
        return [noteRowAction]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let objsInSection = sectionsArray[section]
        guard objsInSection.count > 0 else { return 0 }
        
        return 20
    }
}

