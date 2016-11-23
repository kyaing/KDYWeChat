//
//  KDPersonalDetailViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import SnapKit

let gaps: CGFloat      = 15
let btnHeight: CGFloat = 42
let fontSize: CGFloat  = 16

/// 个人(他人)详情页面
class KDPersonalDetailViewController: UIViewController {

    // MARK: - Parameters
    lazy var detailTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: gaps, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(colorHex: .separatorColor)
        tableView.tableFooterView = self.footerView
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView(frame: CGRectMake(0, 1, 0, 120))
        let sendMsgButton = UIButton()
        let sendVideoButton = UIButton()
        
        sendMsgButton.layer.cornerRadius = 5.0
        sendMsgButton.layer.borderColor = UIColor(colorHex: .separatorColor).CGColor
        sendMsgButton.layer.borderWidth = 0.5
        sendMsgButton.setTitle("发消息", forState: .Normal)
        sendMsgButton.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        sendMsgButton.backgroundColor = UIColor(colorHex: .chatGreenColor)
        sendMsgButton.addTarget(self, action: #selector(self.chatWithMessageAction), forControlEvents: .TouchUpInside)
        
        sendVideoButton.layer.cornerRadius = 5.0
        sendVideoButton.layer.borderColor = UIColor(colorHex: .separatorColor).CGColor
        sendVideoButton.layer.borderWidth = 0.5
        sendVideoButton.setTitle("视频聊天", forState: .Normal)
        sendVideoButton.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        sendVideoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        sendVideoButton.backgroundColor = UIColor.whiteColor()
        sendVideoButton.addTarget(self, action: #selector(self.chatWithAudioAndVideoAction), forControlEvents: .TouchUpInside)
        
        footerView.addSubview(sendMsgButton)
        footerView.addSubview(sendVideoButton)
        
        sendMsgButton.snp_makeConstraints(closure: { (make) in
            make.top.left.right.equalTo(footerView).inset(UIEdgeInsetsMake(20, gaps, 0, gaps))
            make.height.equalTo(btnHeight)
        })
        
        sendVideoButton.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(sendMsgButton.snp_bottom).offset(gaps)
            make.left.right.equalTo(footerView).inset(UIEdgeInsetsMake(0, gaps, 0, gaps))
            make.height.equalTo(btnHeight)
        })
        
        return footerView
    }()
    
    var model: ChatModel!
    var contactModel: ContactModel!
    
    // MARK: - Life Cycle
    init(model: ChatModel?) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "详细资料"
        self.view.backgroundColor = UIColor.clearColor()
        self.detailTableView.reloadData()
    }
    
    // MARK: - Public Methods
    func configureCells(cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.font = UIFont.systemFontOfSize(fontSize)
        
        if indexPath.section == 0 {
            cell.accessoryType = .None
            cell.selectionStyle = .None
            
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "设置备注"
            
        } else {
            if indexPath.row == 0 {
                cell.accessoryType = .None
                cell.selectionStyle = .None
                cell.textLabel?.text = "所在地区"
                
            } else  {
                cell.textLabel?.text = "个人相册"
            }
        }
    }
    
    func configurePushController(indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                
            }
        }
    }
   
    // MARK: - Events Response
    
    /**
     *  发消息事件
     */
    func chatWithMessageAction() {
        guard let model = self.contactModel else { return }
        
        let chatController = KDChatViewController()
        chatController.conversationId = model.username
        chatController.title = model.username
        
        ky_pushViewController(chatController, animated: true)
    }
    
    /**
     *  视频聊天事件
     */
    func chatWithAudioAndVideoAction() {
        
    }
}

// MARK: - UITableViewDataSource
extension KDPersonalDetailViewController:  UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
            
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var detailCell = tableView.dequeueReusableCellWithIdentifier("detailCell")
        if detailCell == nil {
            detailCell = UITableViewCell(style: .Value1, reuseIdentifier: "detailCell")
            detailCell?.accessoryType = .DisclosureIndicator
        }
        
        configureCells(detailCell!, indexPath: indexPath)
        
        return detailCell!
    }
}

// MARK: - UITableViewDelegate
extension KDPersonalDetailViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        configurePushController(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
                return 70
            }
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

