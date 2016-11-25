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
        let rightBarItem = UIBarButtonItem(title: "确定", style: .Plain, target: self, action: #selector(self.editInfoDoneAction))
        
        return rightBarItem
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFontOfSize(15)
        textField.adjustsFontSizeToFitWidth = true
        textField.clearButtonMode = .WhileEditing
        textField.borderStyle = .None
        textField.autocorrectionType = .No
        textField.tintColor = UIColor(colorHex: .tabbarSelectedTextColor)
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
        
        self.edgesForExtendedLayout = .None
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        self.view.backgroundColor = UIColor(colorHex: .tableViewBackgroundColor)
        
        self.title = self.titleStr
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(containerView)
        self.view.addSubview(self.infoTextField)
        
        containerView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_top).offset(20)
            make.height.equalTo(btnHeight)
        }
        
        if let infoStr = self.editInfoStr {
            self.infoTextField.text = infoStr
        } else {
            self.infoTextField.placeholder = self.titleStr
        }
        
        self.infoTextField.snp_makeConstraints(closure: { (make) in
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
            ky_popViewController()
        }
    }
}

