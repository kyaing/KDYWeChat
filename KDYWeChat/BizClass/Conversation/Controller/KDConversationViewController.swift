//
//  KDConversationViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxDataSources
import Then

/// 会话界面
final class KDConversationViewController: UIViewController, EMChatManagerDelegate {
    
    // MARK: - Parameters
    
    /// 数据源
    var messageDataSource = NSMutableArray()
    
    let viewModel = MessageViewModel()
    
    let dataSorce = RxTableViewSectionedReloadDataSource<SectionModel<String, MessageModel>>()
    
    let disposeBag = DisposeBag()
    
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
    
    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.registerReusableCell(MessageTableCell)
        tableView.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        tableView.separatorColor = UIColor(colorHex: .separatorColor)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        tableView.tableHeaderView = self.searchController.searchBar
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        
        return tableView
    }()
    
    // 断网状态的视图
    lazy var networkFailHeaderView: UIView = {
        // $0 确实更简洁，但却没自动提示
        let headerView = UIView().then {
            $0.frame = CGRectMake(0, 0, self.tableView.width, 40)
            $0.backgroundColor = UIColor(colorHex: .networkFailedColor)
        }
        
        let tipLabel = UILabel().then {
            $0.frame = CGRectMake((headerView.width - 300)/2.0, 10, 300, 20)
            $0.textColor = UIColor.grayColor()
            $0.backgroundColor = .clearColor()
            $0.text = "当前网络有问题，请您检查网络"
            $0.font = UIFont.systemFontOfSize(14)
            $0.textAlignment = .Center
            headerView.addSubview($0)
        }
        
        return headerView
    }()
    
    let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_add"), style: .Plain, target: nil,
                                       action: Selector())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        
        self.view.addSubview(self.tableView)
        
        // 配置 ViewModel
        configures(self.viewModel)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        networkIsConnected()
        registerChatDelegate()
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
            self.tableView.tableHeaderView = self.networkFailHeaderView
            
        } else {   // 联网状态
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
    }
    
    /**
     *  获取用户会话列表
     */
    func refreshConversations() {
        // self.realm = RealmHelper.shareInstance.setupRealm()
        // print("path = \(self.realm.configuration.fileURL)")
        
        // 创建数据库
        // FMSQLite.shareInstance.openDB()
        
        getChatConversations()
    }
    
    func handleAddFriendViewAction() {
        
    }
    
    // MARK: - Private Methods
    private func configures(viewModel: MessageViewModel) {
        
        // 按钮点击
        self.rightBarItem.rx_tap
            .bindTo(viewModel.addBarDidTap)
            .addDisposableTo(self.disposeBag)
        
        // 选中cell
        self.tableView.rx_itemSelected
            .bindTo(viewModel.itemSelected)
            .addDisposableTo(self.disposeBag)
        
        // 删除cell
        self.tableView.rx_itemDeleted
            .bindTo(viewModel.itemDeleted)
            .addDisposableTo(self.disposeBag)
        
        // 配置cell
        self.dataSorce.configureCell = {
            _, tableView, indexPath, model in
            let cell: MessageTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.model = model
            
            return cell
        }
        
        // 绑定数据源
        viewModel.getChatConversations()
            .bindTo(self.tableView.rx_itemsWithDataSource(self.dataSorce))
            .addDisposableTo(self.disposeBag)
        
        viewModel.pushChatViewModel
            
    }
    
    /**
     *  网络是否连接 (准确地说是否连上环信服务器)
     */
    func networkIsConnected() {
        // 若没连上环信服务器，应该有重连操作！
        let isConnected = EMClient.sharedClient().isConnected
        if !isConnected {   // 断网状态
            self.tableView.tableHeaderView = self.networkFailHeaderView
            view.addSubview(self.tableView)
            
        } else {   // 联网状态
            self.tableView.tableHeaderView = self.searchController.searchBar
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
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView.reloadData()
        }
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

/*
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
*/