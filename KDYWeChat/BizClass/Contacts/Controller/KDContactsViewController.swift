//
//  KDContactsViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

let contactsIdentifier: String = "contactsCell"

/// 通讯录页面
final class KDContactsViewController: UIViewController {

    var contactsDataSource: NSMutableArray = []
    var sectionsArray: NSMutableArray = []
    var sectionTitlesArray: NSMutableArray = []
    
    var collation: UILocalizedIndexedCollation!
    
    lazy var contactsTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.registerNib(UINib(nibName: "ContactsTableCell", bundle: nil), forCellReuseIdentifier: contactsIdentifier)
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
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.reloadDataArray()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 查询 _User表里的数据
        let query = AVQuery(className: "_User")
        query.getObjectInBackgroundWithId(AVUser.currentUser().objectId) { (object, error) in
            let dic = object.dictionaryForObject()
            print("dic = \(dic)")
        }
    }
    
    // MARK: - Public Methods
    /**
     *  获取好友列表
     */
    func reloadDataArray() {
        
        let friendsName = EMClient.sharedClient().contactManager.getContacts()
        print("friendsName = \(friendsName)")
        
        EMClient.sharedClient().contactManager.getContactsFromServerWithCompletion { (friends, error) in
            
        }
        
        for friend in friendsName {
            let model = ContactModel()
            model.username = friend as? String
            self.contactsDataSource.addObject(model)
        }
        
        let userModel = ContactModel()
        let currentName = EMClient.sharedClient().currentUsername
        userModel.username = currentName
        self.contactsDataSource.addObject(userModel)
        
        // 配置分组
        self.configureSections(contactsDataSource)
        
        self.tableFooterLabel.text = String("\(friendsName.count+1)位联系人")
        self.contactsTableView.tableFooterView = self.tableFooterLabel
        
        self.contactsTableView.reloadData()
    }

    /**
     *  处理好友申请操作
     */
    func handleFrinedRequest() {
        
    }
    
    // MARK: - Private Methods
    /**
     *  配置分组的内容
     */
    func configureSections(dataArray: NSMutableArray) {
        self.collation = UILocalizedIndexedCollation.currentCollation()
        self.sectionTitlesArray = NSMutableArray(array: collation.sectionTitles)
        
        let index = collation.sectionTitles.count
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

        // 去除空的section
        //    for _ in 0..<index {
        //        let array = newSectionArray.objectAtIndex(index)
        //        if array.count == 0 {
        //            self.sectionTitlesArray.removeObjectAtIndex(index)
        //        }
        //    }
        
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
            let userNameInSection = sectionsArray.objectAtIndex(indexPath.section)
            let model = userNameInSection.objectAtIndex(indexPath.row) as! ContactModel
            
            cell.usernameLabel.text = model.username
        }
    }
    
    /**
     *  配置进入下一个的界面
     */
    func configurePushControlelr(indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let newfriendController = KDNewFriendsViewController(nibName: "KDNewFriendsViewController", bundle: nil)
                self.ky_pushViewController(newfriendController, animated: true)
                
            } else if indexPath.row == 1 {
                
            } else {
                
            }
            
        } else {
            
        }
    }
    
    func addFrinedAction() {
        
    }
}

// MARK: - UITableViewDataSource
extension KDContactsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return collation.sectionTitles.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        return sectionsArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contactsCell = tableView.dequeueReusableCellWithIdentifier(contactsIdentifier, forIndexPath: indexPath) as! ContactsTableCell
        
        // 设置Cell的数据
        self.configureCells(contactsCell, indexPath: indexPath)
        
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
        
        return collation.sectionTitles[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return collation.sectionIndexTitles
        
        //    var indexTitles: [String]? = nil
        //    for item in sectionTitlesArray {
        //        indexTitles!.append(item as! String)
        //    }
        //    
        //    return indexTitles
    }
}

// MARK: - UITableViewDelegate
extension KDContactsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.configurePushControlelr(indexPath)
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
        if section == 0 {
            return 10
        }
        
        let objsInSection = sectionsArray[section]
        guard objsInSection.count > 0 else { return 0 }
        
        return 20
    }
}

