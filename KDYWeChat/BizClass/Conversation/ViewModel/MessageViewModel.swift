//
//  MessageViewModel.swift
//  KDYWeChat
//
//  Created by mac on 16/12/1.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class MessageViewModel {
    
    // MARK: - Parameters
    
    let addBarDidTap = PublishSubject<Void>()
    let itemSelected = PublishSubject<IndexPath>()
    let itemDeleted  = PublishSubject<IndexPath>()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    init() {
        
    }
    
    // MARK: - Public Methods

    /**
     *  获取聊天会话
     */
    func getChatConversations() -> Observable<[SectionModel<String, MessageModel>]> {
        
        return Observable.create { (observer) -> Disposable in
            let conversations: NSArray = EMClient.shared().chatManager.getAllConversations() as NSArray 
            
            // 删除最后一条为空的会话
            conversations.enumerateObjects { (conversation, idx, stop) in
                let conversation = conversation as! EMConversation
                if conversation.latestMessage == nil {
                    EMClient.sharedClient().chatManager.deleteConversation(conversation.conversationId,
                        isDeleteMessages: false, completion: nil)
                }
            }
            
            // 按时间的降序，排列会话列表
            let sortedConversations: NSArray = conversations.sortedArray {
                (Obj1, Obj2) -> ComparisonResult in
                
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
            
            var messageDataSource: [MessageModel] = []
            for conversation in sortedConversations as! [EMConversation] {
                let model = MessageModel(conversation: conversation)
                model.lastTime    = self.getlastMessageTimeForConversation(model)
                model.lastContent = self.getLastMessageForConversation(model)
                model.unReadCount = String(model.conversation.unreadMessagesCount)
                
                messageDataSource.append(model)
            }
            
            let sections = [SectionModel(model: "", items: messageDataSource)]
            observer.onNext(sections)
            observer.onCompleted()
        
            return AnonymousDisposable{}
        }
    }

    /**
     *  对应会话的最后一条消息
     */
    func getLastMessageForConversation(_ model: MessageModel) -> String {
        
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
     *  会话的最后一条消息的时间
     */
    func getlastMessageTimeForConversation(_ model: MessageModel) -> String {
        let lastMessage = model.conversation.latestMessage
        if lastMessage == nil { return "" }
        
        // 得到时间戳，把微秒转化成具体时间
        // let timeString = NSDate.formattedTimeFromTimeInterval(lastMessage.timestamp)
        let seconds      = Double((lastMessage?.timestamp)!) / 1000
        let timeInterval = TimeInterval(seconds)
        let date         = Date(timeIntervalSince1970: timeInterval)
        let timeString   = Date.messageAgoSinceDate(date)
        
        return timeString
    }
}

