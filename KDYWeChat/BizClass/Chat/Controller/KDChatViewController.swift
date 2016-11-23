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

let kBarViewHeight: CGFloat        = 50
let kCustomKeyboardHeight: CGFloat = 216

/**
 *  聊天部分，学习并参考：
 *  1). TSWeChat: https://github.com/hilen/TSWeChat
 *  2). JSQMessages: https://github.com/jessesquires/JSQMessagesViewController
 */

/// 聊天界面
final class KDChatViewController: UIViewController {
    
    // MARK: - Parameters
    lazy var chatTableView: UITableView = {
        let chatTableView = UITableView(frame: CGRect.zero, style: .Plain)
        chatTableView.backgroundColor = UIColor.clearColor()
        chatTableView.showsVerticalScrollIndicator = false
        chatTableView.separatorStyle = .None
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        return chatTableView
    }()
    
    lazy var leftBarItem: UIBarButtonItem = {
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "main_back"), style: .Plain, target: self, action: #selector(self.backBarItemAction))
        
        return leftBarItem
    }()
    
    lazy var rightBarItem: UIBarButtonItem = {
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "barbuttonicon_InfoSingle"), style: .Plain, target: self, action: #selector(self.handlePersonAction))
        
        return rightBarItem
    }()
    
    lazy var messageQueue: dispatch_queue_t = {
        let queue = dispatch_queue_create("kdywechat", nil)
        return queue
    }()
    
    var keyboardNoti: NSNotification!
    
    /// 聊天背景图片
    var bgImageView: UIImageView!
    
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
    
    var messageTimeIntervalTag: Int64? = -1
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        
        self.navigationItem.leftBarButtonItem  = self.leftBarItem
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        
        // 创建子视图
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
        
        self.conversation = EMClient.sharedClient().chatManager.getConversation(conversationId, type: EMConversationTypeChat, createIfNotExist: true)
        
        // 未读消息标记为已读
        self.conversation.markAllMessagesAsRead(nil)
        
        // 加载下拉刷新
        setupRefreshControl()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        let imageData = NSUserDefaults.standardUserDefaults().objectForKey(self.conversationId) as? NSData
        if imageData != nil {
            let image = NSKeyedUnarchiver.unarchiveObjectWithData(imageData!) as! UIImage
            
            // 设置聊天背景图片，#bug，当键盘响应后，图片会变形
            // self.chatTableView.backgroundView = UIImageView(image: backgroundImage)
            
            /**
             *  上面的方式不问题，现在修改为在view与tableView间添加张图片，
             *  来做为聊天的背景图片.
             */
            self.bgImageView.image = image
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        PlayMediaManger.shareInstance.stopPlayingVoice()
    }
    
    // MARK: - Public Methods
    func setupRefreshControl() {
        self.chatTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.tableViewHeaderRefreshDatas()
        })
        
        self.chatTableView.mj_header.beginRefreshing()
    }

    func tableViewHeaderRefreshDatas() {
        self.messageTimeIntervalTag = -1
        
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
    
        self.conversation.loadMessagesStartFromId(messageId, count: countOfPage, searchDirection: EMMessageSearchDirectionUp) {
            [weak self] (aMessages, error) in
        
            guard let strongSelf = self else { return }
            strongSelf.chatTableView.mj_header.endRefreshing()
            
            guard error == nil && aMessages.count > 0 else { return }
            
            // 格式化EMMessage消息，成为装有 ChatModel的数组
            let formattedMessages = strongSelf.formatEMMessages(aMessages)
            
            // 下拉刷新时，标记tableView滚动到的位置 (位置滚动的还有问题！)
            var scrollToIndex = 0
            
            dispatch_async(dispatch_get_main_queue()) {
                if isAppendMessage {
                    strongSelf.messageSource.insertObjects(aMessages,
                            atIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, aMessages.count)))
                    
                    scrollToIndex = strongSelf.itemDataSource.count
                    
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
                let indexPath = NSIndexPath(forRow: strongSelf.itemDataSource.count - scrollToIndex - 1, inSection: 0)
                strongSelf.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            }
            
            // 重新下载，下载失败的消息附件
            for message in aMessages as! [EMMessage] {
                strongSelf.downloadMessageAttachments(message)
            }
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
                let messageDate: NSDate = NSDate(timeIntervalSince1970: timeInterval)

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
     *  下载消息附件
     */
    func downloadMessageAttachments(message: EMMessage) {
        let messageBody = message.body
        
        switch messageBody.type {
        case EMMessageBodyTypeImage:
            let imageBody = messageBody as! EMImageMessageBody
            if imageBody.thumbnailDownloadStatus != EMDownloadStatusSuccessed {
                EMClient.sharedClient().chatManager.downloadMessageThumbnail(message, progress: nil, completion: nil)
            }
        
        case EMMessageBodyTypeVoice:
            let voiceBody = messageBody as! EMVoiceMessageBody
            if voiceBody.downloadStatus != EMDownloadStatusSuccessed {
                EMClient.sharedClient().chatManager.downloadMessageThumbnail(message, progress: nil, completion: nil)
            }
            
        default:
            break
        }
    }
    
    // MARK: - Events Reponse
    
    /**
     *  进入个人详细资料
     */
    func handlePersonAction() {
        let settingController = KDChatSettingViewController()
        settingController.conversationId = self.conversationId
        
        ky_pushViewController(settingController, animated: true)
    }
    
    func backBarItemAction() {
        // 直接返回到根控制器即可
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        //    let tabbar     = UIApplication.sharedApplication().keyWindow?.rootViewController as! KDTabBarController
        //    let navigation = tabbar.selectedViewController as! KDNavigationController
        //
        //    navigation.tabBarController?.selectedViewController = tabbar.viewControllers![0]
        //    navigation.popToRootViewControllerAnimated(true)
    }
}

// MARK: - EMChatManagerDelegate
extension KDChatViewController: EMChatManagerDelegate {
    
    /**
     *  接收EMMessage 消息
     */
    func messagesDidReceive(aMessages: [AnyObject]!) {
        for message in aMessages as! [EMMessage] {
            if self.conversation.conversationId == message.conversationId {
                addMessageToDataSource(message)
                
                // 将会话标记为已读，便于统计总的未读消息数
                self.conversation.markMessageAsReadWithId(message.conversationId, error: nil)
            }
        }
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

