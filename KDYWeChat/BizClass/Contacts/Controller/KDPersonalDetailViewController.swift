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
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = KDYColor.TableBackground.color
        tableView.separatorInset = UIEdgeInsets(top: 0, left: gaps, bottom: 0, right: 0)
        tableView.separatorColor = KDYColor.Separator.color
        tableView.tableFooterView = self.footerView
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 1, width: 0, height: 120))
        let sendMsgButton = UIButton()
        let sendVideoButton = UIButton()
        
        sendMsgButton.layer.cornerRadius = 5.0
        sendMsgButton.layer.borderColor = KDYColor.Separator.color.cgColor
        sendMsgButton.layer.borderWidth = 0.5
        sendMsgButton.setTitle("发消息", for: UIControlState())
        sendMsgButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        sendMsgButton.backgroundColor = KDYColor.ChatGreen.color
        sendMsgButton.addTarget(self, action: #selector(self.chatWithMessageAction), for: .touchUpInside)
        
        sendVideoButton.layer.cornerRadius = 5.0
        sendVideoButton.layer.borderColor = KDYColor.Separator.color.cgColor
        sendVideoButton.layer.borderWidth = 0.5
        sendVideoButton.setTitle("视频聊天", for: UIControlState())
        sendVideoButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        sendVideoButton.setTitleColor(UIColor.black, for: UIControlState())
        sendVideoButton.backgroundColor = UIColor.white
        sendVideoButton.addTarget(self, action: #selector(self.chatWithAudioAndVideoAction), for: .touchUpInside)
        
        footerView.addSubview(sendMsgButton)
        footerView.addSubview(sendVideoButton)
        
        sendMsgButton.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(footerView).inset(UIEdgeInsetsMake(20, gaps, 0, gaps))
            make.height.equalTo(btnHeight)
        })
        
        sendVideoButton.snp.makeConstraints({ (make) in
            make.top.equalTo(sendMsgButton.snp.bottom).offset(gaps)
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
        self.view.backgroundColor = UIColor.clear
        self.detailTableView.reloadData()
    }
    
    // MARK: - Public Methods
    func configureCells(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
        } else if (indexPath as NSIndexPath).section == 1 {
            cell.textLabel?.text = "设置备注"
            
        } else {
            if (indexPath as NSIndexPath).row == 0 {
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.textLabel?.text = "所在地区"
                
            } else  {
                cell.textLabel?.text = "个人相册"
            }
        }
    }
    
    func configurePushController(_ indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            if (indexPath as NSIndexPath).row == 0 {
                kyPushViewController(KDEditInfoViewController(title: "备注信息"), animated: true)
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
        
        kyPushViewController(chatController, animated: true)
    }
    
    /**
     *  视频聊天事件
     */
    func chatWithAudioAndVideoAction() {
        
    }
}

// MARK: - UITableViewDataSource
extension KDPersonalDetailViewController:  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
            
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var detailCell = tableView.dequeueReusableCell(withIdentifier: "detailCell")
        if detailCell == nil {
            detailCell = UITableViewCell(style: .value1, reuseIdentifier: "detailCell")
            detailCell?.accessoryType = .disclosureIndicator
        }
        
        configureCells(detailCell!, indexPath: indexPath)
        
        return detailCell!
    }
}

// MARK: - UITableViewDelegate
extension KDPersonalDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        configurePushController(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 70
        } else if (indexPath as NSIndexPath).section == 2 {
            if (indexPath as NSIndexPath).row == 1 {
                return 70
            }
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

