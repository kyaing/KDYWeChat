//
//  KDConversationViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

let messageIdentifier: String = "messageCell"

/// 会话界面
final class KDConversationViewController: UIViewController, EMChatManagerDelegate {
    
    var messageDataSource = NSMutableArray()
    
    lazy var conversationTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor)
        tableView.separatorColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        tableView.registerNib(UINib(nibName: "MessageTableCell", bundle: nil), forCellReuseIdentifier: messageIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 65
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    // 断网状态的头视图
    lazy var networkFailHeaderView: UIView = {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.conversationTableView.width, 40))
        headerView.backgroundColor = UIColor(red: 255/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        
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
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_add"), style: .Plain, target: self, action: #selector(self.handleAddViewAction))
        
        return rightBarItem
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.networkIsConnected()
        self.registerChatDelegate()
        self.refreshConversations()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.unRegisterChatDelegate()
    }
    
    deinit {
        self.unRegisterChatDelegate()
    }
    
    // MARK: - Public Methods
    func networkStateChanged(connectionState: EMConnectionState) {
        if connectionState == EMConnectionDisconnected {   // 断网状态
            self.conversationTableView.tableHeaderView = self.networkFailHeaderView
            
        } else {
            self.conversationTableView.tableHeaderView = UIView()
        }
    }
    
    /**
     *  获取用户会话列表
     */
    func refreshConversations() {
        getAllConversation()
    }
    
    func handleAddViewAction() {
        
    }
    
    // MARK: - Private Methods
    /**
     *  网络是否连接
     */
    func networkIsConnected() {
        let isConnected = EMClient.sharedClient().isConnected
        if !isConnected {   // 断网状态
            self.conversationTableView.tableHeaderView = self.networkFailHeaderView
            view.addSubview(self.conversationTableView)
            
        } else {
            self.conversationTableView.tableHeaderView = UIView()
        }
    }
    
    /**
     *  获得该用户的所有会话
     */
    private func getAllConversation() {
        let conversations: NSArray = EMClient.sharedClient().chatManager.getAllConversations()
        let sortedConversations: NSArray = conversations.sortedArrayUsingComparator { (Obj1, Obj2) -> NSComparisonResult in
            let message1 = Obj1 as! MessageModel
            let message2 = Obj2 as! MessageModel
            
            if message1.conversation.latestMessage.timestamp >
                message2.conversation.latestMessage.timestamp {
                return .OrderedAscending
            } else {
                return .OrderedDescending
            }
        }
        
        messageDataSource.removeAllObjects()
        for conversation in sortedConversations as! [EMConversation] {
            let model = MessageModel(conversation: conversation)
            self.messageDataSource.addObject(model)
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.conversationTableView.reloadData()
        }
    }
    
    /**
     *  由数据模型，得到对应会话的最后一条消息
     */
    func getLastMessageForConversation(model: MessageModel) -> String? {
        var latestMsgTitle: String?
        
        let messageBody = model.conversation.latestMessage.body
        switch messageBody.type {
            
        // 只有文本消息，才有最后一条数据，其它都是自已拼的
        case EMMessageBodyTypeText:
            let textBody = messageBody as! EMTextMessageBody
            latestMsgTitle = textBody.text
            
        case EMMessageBodyTypeImage:    latestMsgTitle = "[图片]"
        case EMMessageBodyTypeVoice:    latestMsgTitle = "[语音]"
        case EMMessageBodyTypeVideo:    latestMsgTitle = "[视频]"
        case EMMessageBodyTypeLocation: latestMsgTitle = "[位置]"
        case EMMessageBodyTypeFile:     latestMsgTitle = "[文件]"
            
        default: latestMsgTitle = ""
        }
        
        return latestMsgTitle!
    }
    
    /**
     *  由数据模型，得到对应会话的最后一条消息的时间
     */
    func getlastMessageTimeForConversation(model: MessageModel) -> String {
        let lastMessage = model.conversation.latestMessage
        
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

// MARK: - UITableViewDataSource
extension KDConversationViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageDataSource.count > 0 ? self.messageDataSource.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(messageIdentifier, forIndexPath: indexPath) as! MessageTableCell
        
        let model = self.messageDataSource.objectAtIndex(indexPath.row) as! MessageModel
        
        // 设置Cell的数据
        let lastMessage     = self.getLastMessageForConversation(model)
        let lastMessageTime = self.getlastMessageTimeForConversation(model)
        
        cell.avatorImageView.image  = model.avatarImage
        let unreadMessageCount = model.conversation.unreadMessagesCount
        cell.unReadMsgLabel.text = String(unreadMessageCount)
        // 气泡大小的处理，要优化
        if unreadMessageCount > 9 {
            cell.unReadMsgLabel.font = UIFont.systemFontOfSize(11)
        }
        
        cell.userNameLabel.text     = model.title
        cell.lastMessageLabel?.text = lastMessage
        cell.lastMsgDateLabel.text  = lastMessageTime
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KDConversationViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let chatController = KDChatViewController()
        chatController.title = "消息"
        self.ky_pushAndHideTabbar(chatController)
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

