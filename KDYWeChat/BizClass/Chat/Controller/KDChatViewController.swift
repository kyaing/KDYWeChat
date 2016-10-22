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

/// 聊天界面 (学习TSWeChat)
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorHex: KDYColor.tableViewBackgroundColor)
        
        // 添加子视图
        setupChildViews()
        
        // 处理BarView的交互
        setupBarViewInteraction()
        
        // 键盘控制
        keyboardControl()
        
        // 在第一条数据前，插入一条timeModel
        let model0 = ChatModel(timestamp: "9-27")
        let model1 = ChatModel(text: "我是测试，哈哈...我是测试我1234543，哈哈...我是测试我是测试，哈哈...我是测试我是测试，..我是测试我是测试，哈哈...我是测试，哈哈魂牵梦萦fdafdaa dafdas32323##____@#4q56r，哈哈...我是测试，哈哈...我是测试，哈哈...")
        let model2 = ChatModel(text: "不知道要写什么。。。哈哈，，测试测试。。。")
        let model3 = ChatModel(text: "今天风实在太大了，头疼！！！[头疼][大笑]000000####%%%%fdaf暮云春树革【|、·1234567")
        let model4 = ChatModel(text: "000000####%%%%fdaf暮云春树革【|、·1234567")
        let array = [model0, model1, model2, model3, model4]
        itemDataSouce.addObjectsFromArray(array)
    }
}

// MARK: - UITableViewDataSource
extension KDChatViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDataSouce.count
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

