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

/**
 *  聊天部分，学习并参考：
 *  1). TSWeChat: https://github.com/hilen/TSWeChat
 *  2). JSQMessages: https://github.com/jessesquires/JSQMessagesViewController
 *
 */

/// 聊天界面
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
    
    lazy var rightBarItem: UIBarButtonItem = {
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_InfoSingle"), style: .Plain, target: self, action: #selector(self.handlePersonAction))
        
        return rightBarItem
    }()
    
    lazy var messageQueue: dispatch_queue_t = {
        let queue = dispatch_queue_create("kdywechat", nil)
        return queue
    }()
    
    /// 底部工具栏
    var bottomBarView: ChatBottomBarView!
    
    var barPaddingBottomConstranit: Constraint?
    
    /// 表情键盘
    var emotionView: ChatEmotionView!
    
    /// 扩展键盘
    var shareView: ChatShareMoreView!
    
    /// 录音视图
    var recordingView: ChatRecordingView!
    
    /// 当前播放语音的Cell
    var currentVoiceCell: ChatAudioTableCell!
    
    let disposeBag = DisposeBag()
    
    /// 存储 ChatModel数据源
    var itemDataSource = NSMutableArray()
    
    /// 存储 EMEmessage消息源
    var messageSource = NSMutableArray()
    
    var conversationId: String!
    var conversation: EMConversation!
    
    var messageTimeIntervalTag: Int64?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor)
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        
        setupChildViews()
        
        // 处理底部工具栏交互
        setupBarViewInteraction()
        
        // 键盘控制
        keyboardControl()
        
        // 设置多媒体的代理
        RecordManager.shareInstance.mediaDelegate   = self
        VideoManger.shareInstance.mediaDelegate     = self
        PlayMediaManger.shareInstance.mediaDelegate = self
        
        // 聊天的回调
        EMClient.sharedClient().chatManager.addDelegate(self, delegateQueue: nil)
        
        // 刷新加载，会话消息列表
        tableViewHeaderRefreshDatas()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        PlayMediaManger.shareInstance.stopPlayingVoice()
    }
    
    // MARK: - Public Methods
    /**
     *  下拉刷新 tableView数据
     */
    func tableViewHeaderRefreshDatas() {
        self.messageTimeIntervalTag = -1;
        
        var messageId: String?
        if self.messageSource.count > 0 {
            messageId = (self.messageSource.firstObject as! EMMessage).messageId
            
        } else {
            messageId = nil
        }
        
        // 根据messageId加载数据，每页10条
        loadMessageBefore(messageId, countOfPage: 10, isAppendMessage: true)
    }

    func loadMessageBefore(messageId: String?, countOfPage: Int32, isAppendMessage: Bool) {
        self.conversation =
            EMClient.sharedClient().chatManager.getConversation(conversationId, type: EMConversationTypeChat, createIfNotExist: true)
        
        self.conversation.loadMessagesStartFromId(messageId, count: countOfPage, searchDirection: EMMessageSearchDirectionUp) {
            [weak self] (aMessages, error) in
            
            guard let strongSelf = self else { return }
            guard error == nil && aMessages.count > 0 else { return }
            
            // 格式化EMMessage消息，成为装有 ChatModel的数组
            let formattedMessages = strongSelf.formatEMMessages(aMessages)
            
            dispatch_async(dispatch_get_main_queue(), {
                if isAppendMessage {
                    strongSelf.messageSource.insertObjects(aMessages,
                            atIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, aMessages.count)))
                    
                    // 注意 itemDataSouce，应该以 formattedMessages 来计算范围
                    strongSelf.itemDataSource.insertObjects(formattedMessages,
                            atIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, formattedMessages.count)))
                    
                } else {
                    strongSelf.messageSource.removeAllObjects()
                    strongSelf.messageSource.addObjectsFromArray(formattedMessages)
                }
                
                let latestMessage = strongSelf.messageSource.lastObject as! EMMessage
                strongSelf.messageTimeIntervalTag = latestMessage.timestamp
                
                strongSelf.chatTableView.reloadData()
                
                // 滚动动tableView的底部
                let indexPath = NSIndexPath(forRow: strongSelf.itemDataSource.count - 1, inSection: 0)
                strongSelf.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            })
        }
    }
    
    /**
     *  格式化EMessage 消息
     */
    func formatEMMessages(messages: [AnyObject]) -> [AnyObject] {
        var formatMessages: [AnyObject] = []
        
        for message in messages as! [EMMessage] {
            let interval = (self.messageTimeIntervalTag! - message.timestamp) / 1000
            if (self.messageTimeIntervalTag < 0
                                || interval > 60
                                || interval < -60) {
                
                let seconds = Double(message.timestamp) / 1000
                let timeInterval = NSTimeInterval(seconds)
                let messageDate: NSDate = NSDate(timeIntervalSinceNow: timeInterval)

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd HH:mm"
                let timeString = dateFormatter.stringFromDate(messageDate)

                // 时间间隔超过一分钟，插入数据源中
                let timeModel = ChatModel(timestamp: timeString)
                formatMessages.append(timeModel)

                self.messageTimeIntervalTag = message.timestamp
            }

            // 除了时间外，插入其它的消息数据源
            let messageModel = ChatModel(message: message)
            formatMessages.append(messageModel)
        }
        
        return formatMessages
    }
    
    /**
     *  进入聊天设置界面
     */
    func handlePersonAction() {
        ky_pushViewController(KDChatSettingViewController(), animated: true)
    }
}

// MARK: - UITableViewDataSource
extension KDChatViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let chatModel = itemDataSource.objectAtIndex(indexPath.row) as? ChatModel
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
        let chatModel = self.itemDataSource.objectAtIndex(indexPath.row) as? ChatModel
        guard let type: MessageContentType = chatModel!.messageContentType where chatModel != nil else { return 0 }
     
        return type.chatCellHeight(chatModel!)
    }
}

