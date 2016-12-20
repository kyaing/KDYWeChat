//
//  KDRegisterViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/13.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

/// 注册页面
final class KDRegisterViewController: UIViewController {

    // MARK: - Parameters
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        setupViewsUI()
    }
    
    func setupViewsUI() {
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 0.5
        registerButton.layer.borderColor = KDYColor.Separator.color.cgColor
        registerButton.backgroundColor = KDYColor.ChatLightGreen.color
        
        cancelButton.setTitleColor(KDYColor.TabbarSelectedText.color, for: UIControlState())
        
        // 修改光标颜色
        mailTextField.tintColor    = KDYColor.TabbarSelectedText.color
        accountTextField.tintColor = self.mailTextField.tintColor
        passwordTextFiled.tintColor = self.mailTextField.tintColor
    }

    // MARK: - Event Responses
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonAction(_ sender: AnyObject) {
        
        /**
         *  注册环信，并同时注册LeanClound，建立 _User表
         */
        let mail     = self.mailTextField.text
        let username = self.accountTextField.text
        let password = self.passwordTextFiled.text
        
        EMClient.shared().register(withUsername: username, password: password) { (account, error) in
            if error != nil {
                print("注册环信失败！error = \(error?.description)")
            } else {   // 成功后，注册LeanCloud..
                print(">>> 注册环信成功 <<<")
                self.loginLeanCloud(mail!, userName: username!, password: password!)
            }
        }
    }
    
    func loginLeanCloud(_ mail: String, userName: String, password: String) {
        let user = AVUser()
        user.email    = mail
        user.username = userName
        user.password = password
        
        user.signUpInBackground({ (succeeded, error) in
            if succeeded {
                // 跳转到tabbar
                print(">>> 注册LeanCloud成功 <<<")
                
            } else {
                print(">>> 注册LeanCloud失败 <<<")
            }
        })
    }
    
    func hideKeyboard() {
        self.mailTextField.resignFirstResponder()
        self.accountTextField.resignFirstResponder()
        self.passwordTextFiled.resignFirstResponder()
    }
}

