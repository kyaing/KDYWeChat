//
//  KDConversationViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import RealmSwift

/// 会话界面
final class KDConversationViewController: UIViewController, EMChatManagerDelegate {
    
    // MARK: - Parameters
    
    /// 数据源
    var messageDataSource = NSMutableArray()
    
    var realm: Realm!
    
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
    
    lazy var conversationTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        tableView.separatorColor = UIColor(colorHex: .separatorColor)
        tableView.registerReusableCell(MessageTableCell)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        tableView.tableHeaderView = self.searchController.searchBar
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    // 断网状态的视图
    lazy var networkFailHeaderView: UIView = {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.conversationTableView.width, 40))
        headerView.backgroundColor = UIColor(colorHex: .networkFailedColor)
        
        let tipLabel = UILabel(frame: CGRectMake((headerView.width - 300)/2.0, 10, 300, 20))
        tipLabel.textColor = UIColor.grayColor()
        tipLabel.backgroundColor = UIColor.clearColor()
        tipLabel.text = "当前网络有问题，请您检查网络"
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.textAlignment = .Center
        headerView.addSubview(tipLabel)
        
        return headerView
    }()
    
    lazy var rightBarItem: UIBarButtonItem = {
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_add"), style: .Plain, target: self, action: #selector(self.handleAddFriendViewAction))
        
        return rightBarItem
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        networkIsConnected()
        registerChatDelegate()
        
        refreshConversations()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unRegisterChatDelegate()
    }
    
    deinit {
        unRegisterChatDelegate()
    }
    
    // MARK: - Public Methods
    func networkStateChanged(connectionState: EMConnectionState) {
        if connectionState == EMConnectionDisconnected {   // 断网状态
            self.conversationTableView.tableHeaderView = self.networkFailHeaderView
            
        } else {   // 联网状态
            self.conversationTableView.tableHeaderView = self.searchController.searchBar
        }
    }
    
    /**
     *  获取用户会话列表
     */
    func refreshConversations() {
        // self.realm = RealmHelper.shareInstance.setupRealm()
        // print("path = \(self.realm.configuration.fileURL)")
        
        getChatConversations()
    }
    
    func handleAddFriendViewAction() {
        
    }
    
    // MARK: - Private Methods
    
    /**
     *  网络是否连接 (准确地说是否连上环信服务器)
     */
    func networkIsConnected() {
        // 若没连上环信服务器，应该有重连操作！
        let isConnected = EMClient.sharedClient().isConnected
        if !isConnected {   // 断网状态
            self.conversationTableView.tableHeaderView = self.networkFailHeaderView
            view.addSubview(self.conversationTableView)
            
        } else {   // 联网状态
            self.conversationTableView.tableHeaderView = self.searchController.searchBar
        }
    }
    
    private func getChatConversations() {
        let conversations: NSArray = EMClient.sharedClient().chatManager.getAllConversations()
        if conversations.count == 0 { return }

        // 删除最后一条为空的会话
        conversations.enumerateObjectsUsingBlock({ (conversation, idx, stop) in
            let conversation = conversation as! EMConversation
            if conversation.latestMessage == nil {
                EMClient.sharedClient().chatManager.deleteConversation(conversation.conversationId,
                    isDeleteMessages: false, completion: nil)
            }
        })
        
        // 按时间的降序，排列会话列表
        let sortedConversations: NSArray = conversations.sortedArrayUsingComparator {
            (Obj1, Obj2) -> NSComparisonResult in
        
            let message1 = Obj1 as? EMConversation
            let message2 = Obj2 as? EMConversation
            
            if message1?.latestMessage != nil && message2?.latestMessage != nil {
                if message1!.latestMessage.timestamp >
                    message2!.latestMessage.timestamp {
                    return .OrderedAscending
                } else {
                    return .OrderedDescending
                }
            }
            
            return .OrderedSame
        }
    
        self.messageDataSource.removeAllObjects()
        for conversation in sortedConversations as! [EMConversation] {
            
            let model = MessageModel(conversation: conversation)
            self.messageDataSource.addObject(model)
            
            // 存储到Realm数据库
            //    try! self.realm.write {
            //        let realmModel = MessageRealmModel()
            //        realmModel.nickname    = conversation.conversationId
            //        realmModel.lastContent = self.getLastMessageForConversation(model)!
            //        realmModel.time        = self.getlastMessageTimeForConversation(model)
            //        
            //        // 存储头像数据流
            //        if let userInfo = UserInfoManager.shareInstance.getUserInfoByName(model.conversation.conversationId) {
            //            if userInfo.imageUrl != nil {
            //                let avatarData = NSData(contentsOfURL: NSURL(string: userInfo.imageUrl!)!)
            //                realmModel.avatarData = avatarData
            //            }
            //        }
            //        
            //        self.realm.add(realmModel)
            //    }
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.conversationTableView.reloadData()
        }
    }
    
    /**
     *  由数据模型，得到对应会话的最后一条消息
     */
    func getLastMessageForConversation(model: MessageModel) -> String? {
        
        var latestMsgTitle: String = ""
        if let message = model.conversation.latestMessage {
            
            switch message.body.type {
            // 除了文本消息，其它都是自已判断
            case EMMessageBodyTypeText:
                let textBody = message.body as! EMTextMessageBody
                latestMsgTitle = textBody.text

            case EMMessageBodyTypeImage:    latestMsgTitle = "[图片]"
            case EMMessageBodyTypeVoice:    latestMsgTitle = "[语音]"
            case EMMessageBodyTypeVideo:    latestMsgTitle = "[视频]"
            case EMMessageBodyTypeLocation: latestMsgTitle = "[位置]"
            case EMMessageBodyTypeFile:     latestMsgTitle = "[文件]"
        
            default: latestMsgTitle = ""
            }
            
            return latestMsgTitle
        }
        
        return ""
    }
    
    /**
     *  得到对应会话的最后一条消息的时间
     */
    func getlastMessageTimeForConversation(model: MessageModel) -> String {
        let lastMessage = model.conversation.latestMessage
        if lastMessage == nil { return "" }
        
        // 得到时间戳，把微秒转化成具体时间
        // let timeString = NSDate.formattedTimeFromTimeInterval(lastMessage.timestamp)
        let seconds = Double(lastMessage.timestamp) / 1000
        let timeInterval: NSTimeInterval = NSTimeInterval(seconds)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let timeString = NSDate.messageAgoSinceDate(date)
        
        return timeString
    }
    
    func registerChatDelegate() {
        EMClient.sharedClient().chatManager.addDelegate(self, delegateQueue: nil)
    }
    
    func unRegisterChatDelegate() {
        EMClient.sharedClient().chatManager.removeDelegate(self)
    }
}

// MARK: - UISearchResultsUpdating
extension KDConversationViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
}

// MARK: - UISearchControllerDelegate
extension KDConversationViewController: UISearchControllerDelegate {
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
extension KDConversationViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageDataSource.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MessageTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
        
        let model = self.messageDataSource.objectAtIndex(indexPath.row) as! MessageModel
        
        // 设置Cell的数据
        let lastMessage     = getLastMessageForConversation(model)
        let lastMessageTime = getlastMessageTimeForConversation(model)
        
        let unreadMessageCount = model.conversation.unreadMessagesCount
        if unreadMessageCount > 0 {
            cell.unReadMsgLabel.hidden = false
            cell.unReadMsgLabel.text = String(unreadMessageCount)
            
            // 处理气泡的大小
            if unreadMessageCount > 9 {
                cell.unReadMsgWidthContraint.constant  = 23
                cell.unReadMsgHeightContriant.constant = 18
                cell.unReadMsgLabel.layer.cornerRadius = 9
                
                if unreadMessageCount > 99 {
                    cell.unReadMsgLabel.text = "99"
                }
                
            } else {
                cell.unReadMsgWidthContraint.constant  = 19
                cell.unReadMsgHeightContriant.constant = 19
                cell.unReadMsgLabel.layer.cornerRadius = 9.5
            }
            
        } else {
            cell.unReadMsgLabel.hidden = true
        }
        
        cell.userNameLabel.text     = model.title
        cell.lastMessageLabel?.text = lastMessage
        cell.lastMsgDateLabel.text  = lastMessageTime
        
        if let userInfo = UserInfoManager.shareInstance.getUserInfoByName(model.conversation.conversationId) {
            if userInfo.imageUrl != nil {
                cell.avatorImageView.kf_setImageWithURL(NSURL(string: userInfo.imageUrl!), placeholderImage: UIImage(named: kUserAvatarDefault), optionsInfo: nil)
            } else {
                cell.avatorImageView.image = UIImage(named: kUserAvatarDefault)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KDConversationViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let model = self.messageDataSource.objectAtIndex(indexPath.row) as! MessageModel
    
        let chatController = KDChatViewController()
        chatController.conversationId = model.conversation.conversationId
        chatController.title = model.title
        ky_pushAndHideTabbar(chatController)
        
        // 发送未读消息的通知
        NSNotificationCenter.defaultCenter().postNotificationName(unReadMessageCountNoti, object: self, userInfo: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // 添加备注按钮
        let noteRowAction = UITableViewRowAction(style: .Default, title: "删除") { (rowAction, indexPath) in
            print(">>> 删除聊天 <<<")
        }
        
        return [noteRowAction]
    }
}

