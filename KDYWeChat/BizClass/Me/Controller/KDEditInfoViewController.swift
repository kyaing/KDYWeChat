//
//  KDEditInfoViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/18.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import SnapKit

typealias editDoneAction = (String) -> Void

/// 编辑信息界面
class KDEditInfoViewController: UIViewController {
    
    var titleStr: String?
    var editInfoStr: String?
    
    lazy var rightBarItem: UIBarButtonItem = {
        let rightBarItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(self.editInfoDoneAction))
        
        return rightBarItem
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.adjustsFontSizeToFitWidth = true
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.tintColor = KDYColor.TabbarSelectedText.color
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    var editDoneClosure: editDoneAction?
    
    // MARK: - Life Cycle
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleStr = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        self.view.backgroundColor = KDYColor.TableBackground.color
        
        self.title = self.titleStr
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        self.view.addSubview(containerView)
        self.view.addSubview(self.infoTextField)
        
        containerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(20)
            make.height.equalTo(btnHeight)
        }
        
        if let infoStr = self.editInfoStr {
            self.infoTextField.text = infoStr
        } else {
            self.infoTextField.placeholder = self.titleStr
        }
        
        self.infoTextField.snp.makeConstraints({ (make) in
            make.edges.equalTo(containerView).inset(UIEdgeInsetsMake(0, gaps, 0, gaps))
        })
    }
    
    // MARK: - Event Response
    
    /**
     *  编辑确定事件
     */
    func editInfoDoneAction() {
        if let editClosure = self.editDoneClosure {
            editClosure(self.infoTextField.text!)
            kyPopViewController()
        }
    }
}

