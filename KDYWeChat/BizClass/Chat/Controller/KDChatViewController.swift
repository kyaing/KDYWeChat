//
//  KDChatViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import UIColor_Hex_Swift

let kBarViewHeight: CGFloat        = 50
let kCustomKeyboardHeight: CGFloat = 216

/// 聊天界面 (重点学习并参考 -> TSWeChat_开源项目)
final class KDChatViewController: UIViewController {
    
    lazy var chatTableView: UITableView = {
        let chatTableView = UITableView(frame: CGRect.zero, style: .Plain)
        chatTableView.backgroundColor = UIColor.clearColor()
        chatTableView.showsVerticalScrollIndicator = false
        chatTableView.separatorStyle = .None
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        return chatTableView
    }()

    var bottomBarView: ChatBottomBarView!
    var barPaddingBottomConstranit: Constraint?
    
    var emotionView: ChatEmotionView!
    var shareView: ChatShareMoreView!
    
    let disposeBag = DisposeBag()
    var itemDataSouce = NSMutableArray()
    
    var conversationId: String!
    var conversation: EMConversation!
    
    var messageTimeIntervalTag: Int64?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor)
        
        setupChildViews()
        
        // 处理BarView的交互
        setupBarViewInteraction()
        
        // 键盘控制
        keyboardControl()
        
        // 加载会话消息
        loadMessageBefroe(nil, count: 10, append: true)
    }
    
    // MARK: - Public Methods
    func loadMessageBefroe(messageId: String?, count: Int32, append: Bool) {
        
        self.conversation = EMClient.sharedClient().chatManager.getConversation(conversationId, type: EMConversationTypeChat, createIfNotExist: true)
        
        self.conversation.loadMessagesStartFromId(messageId, count: count, searchDirection: EMMessageSearchDirectionUp) { (aMessages, error) in
            
            guard error == nil && aMessages.count > 0 else { return }
            
            let lasetMessage = aMessages.last as! EMMessage
            self.messageTimeIntervalTag = lasetMessage.timestamp
            
            for message in aMessages as! [EMMessage] {
                let interval = (self.messageTimeIntervalTag! - message.timestamp) / 1000
                
                if (self.messageTimeIntervalTag < 0 ||
                                      interval > 60 ||
                                      interval < -60) {
                    let seconds = Double(message.timestamp) / 1000
                    let timeInterval = NSTimeInterval(seconds)
                    let messageDate: NSDate = NSDate(timeIntervalSinceNow: timeInterval)
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM-dd HH:mm"
                    let timeString = dateFormatter.stringFromDate(messageDate)
                    
                    // 时间间隔超过一分钟，插入数据源中
                    let timeModel = ChatModel(timestamp: timeString)
                    self.itemDataSouce.addObject(timeModel)
                    
                    self.messageTimeIntervalTag = message.timestamp
                }
                
                // 除了时间，插入其它的消息数据源
                let messageModel = ChatModel(message: message)
                self.itemDataSouce.addObject(messageModel)
            }
            
            self.chatTableView.reloadData()
            
            // 滚动动tableView的底部
            let indexPath = NSIndexPath(forRow: self.itemDataSouce.count - 1, inSection: 0)
            self.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        }
    }
}

// MARK: - UITableViewDataSource
extension KDChatViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSouce.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let chatModel = itemDataSouce.objectAtIndex(indexPath.row) as? ChatModel
        guard let type: MessageContentType = chatModel!.messageContentType where chatModel != nil else {
            return ChatBaseTableCell()
        }
        
        return type.chatCell(tableView, indexPath: indexPath, model: chatModel!, viewController: self)!
    }
}

// MARK: - UITableViewDelegate
extension KDChatViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let chatModel = itemDataSouce.objectAtIndex(indexPath.row) as? ChatModel
        guard let type: MessageContentType = chatModel!.messageContentType where chatModel != nil else { return 0 }
     
        return type.chatCellHeight(chatModel!)
    }
}

