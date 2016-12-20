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
    
    /// 搜索控制器
    lazy var searchController: UISearchController = {
        let search: UISearchController = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.tintColor = KDYColor.ChatGreen.color
        search.searchBar.sizeToFit()
        
        return search
    }()

    
    lazy var tableView: UITableView = {
        let tb: UITableView = UITableView(frame: self.view.bounds, style: .plain)
        tb.backgroundColor = KDYColor.TableBackground.color
        tb.separatorColor  = KDYColor.Separator.color
        tb.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        tb.register(cellType: MessageTableCell.self)
        tb.tableHeaderView = self.searchController.searchBar
        tb.tableFooterView = UIView()
        tb.rowHeight = 60
        
        return tb
    }()
    
    // 断网状态的视图
    lazy var networkFailHeaderView: UIView = {
        // $0 确实更简洁，但却没自动提示
        let headerView = UIView().then {
            $0.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.tableView.width, height: 40))
            $0.backgroundColor = KDYColor.NetworkFailed.color
        }
        
        let tipLabel = UILabel().then {
            $0.frame = CGRect(origin: CGPoint(x: (headerView.width - 300)/2.0, y: 10), size: CGSize(width: 300, height: 20))
            $0.textColor = .gray
            $0.backgroundColor = .clear
            $0.text = "当前网络有问题，请您检查网络"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textAlignment = .center
            headerView.addSubview($0)
        }
        
        return headerView
    }()
    
    let viewModel = MessageViewModel()
    
    let dataSorce = RxTableViewSectionedReloadDataSource<SectionModel<String, MessageModel>>()
    
    let disposeBag = DisposeBag()
    
    let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_add"), style: .plain,
                                       target: nil, action: #selector(addAction))
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        // 配置 ViewModel
        configures(viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkIsConnected()
        registerChatDelegate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unRegisterChatDelegate()
    }
    
    deinit {
        unRegisterChatDelegate()
    }
    
    // MARK: - Public Methods
    func networkStateChanged(_ connectionState: EMConnectionState) {
        if connectionState == EMConnectionDisconnected {   // 断网状态
            view.addSubview(tableView)
            tableView.tableHeaderView = self.networkFailHeaderView

        } else {   // 联网状态
            view.addSubview(tableView)
            tableView.tableHeaderView = self.searchController.searchBar
        }
    }
    
    func addAction() {
        
    }
    
    /**
     *  获取用户会话列表
     */
    func refreshConversations() {
        getChatConversations()
    }
    
    // MARK: - Private Methods
    fileprivate func configures(_ viewModel: MessageViewModel) {
        
        // 按钮点击
        rightBarItem.rx.tap
            .bindTo(viewModel.addBarDidTap)
            .addDisposableTo(disposeBag)
        
        rightBarItem.rx.tap
            .subscribe {
                
            }
            .addDisposableTo(disposeBag)
        
        // 选中cell (写法更简洁)
        tableView.rx.itemSelected
            .bindTo(viewModel.itemSelected)
            .addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(MessageModel.self)
            .subscribe(onNext: { model in
                
                let chatController = KDChatViewController()
                chatController.conversationId = model.conversation.conversationId
                chatController.title = model.title
                self.ky_pushAndHideTabbar(chatController)
                
                // 发送未读消息的通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: unReadMessageCountNoti), object: self)
                }) {
            }
            .addDisposableTo(disposeBag)
        
        // 删除cell
        tableView.rx.itemDeleted
            .bindTo(viewModel.itemDeleted)
            .addDisposableTo(disposeBag)
        
        // 配置cell
        dataSorce.configureCell = { _, tableView, indexPath, model in
            let cell: MessageTableCell = tableView.dequeueReusableCell(for: indexPath)
            cell.model = model
            return cell
        }
        
        // 绑定数据源
        viewModel.getChatConversations()
            .bindTo(tableView.rx.items(dataSource: dataSorce))
            .addDisposableTo(disposeBag)
    }
    
    /**
     *  是否连上环信服务器
     */
    func networkIsConnected() {
        let isConnected = EMClient.shared().isConnected
        if !isConnected {   // 断网状态
            view.addSubview(tableView)
            tableView.tableHeaderView = networkFailHeaderView
            
        } else {   // 联网状态
            view.addSubview(tableView)
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    fileprivate func getChatConversations() {
        let conversations: NSArray = EMClient.shared().chatManager.getAllConversations() as NSArray
        if conversations.count == 0 { return }

        // 删除最后一条为空的会话
        conversations.enumerateObjects({ (conversation, idx, stop) in
            let conversation = conversation as! EMConversation
            if conversation.latestMessage == nil {
                EMClient.shared().chatManager.deleteConversation(conversation.conversationId,
                    isDeleteMessages: false, completion: nil)
            }
        })
        
        // 按时间的降序，排列会话列表
        let sortedConversations: NSArray = conversations.sortedArray (comparator: {
            (Obj1, Obj2) -> ComparisonResult in
        
            let message1 = Obj1 as? EMConversation
            let message2 = Obj2 as? EMConversation
            
            if message1?.latestMessage != nil && message2?.latestMessage != nil {
                if message1!.latestMessage.timestamp >
                    message2!.latestMessage.timestamp {
                    return .orderedAscending
                } else {
                    return .orderedDescending
                }
            }
            
            return .orderedSame
        }) as NSArray
    
        self.messageDataSource.removeAllObjects()
        for conversation in sortedConversations as! [EMConversation] {
            
            let model = MessageModel(conversation: conversation)
            messageDataSource.add(model)
        }
        
        DispatchQueue.main.async { 
            self.tableView.reloadData()
        }
    }
    
    func registerChatDelegate() {
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
    }
    
    func unRegisterChatDelegate() {
        EMClient.shared().chatManager.remove(self)
    }
}

