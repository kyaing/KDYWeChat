//
//  KDRegisterViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/13.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud

class KDRegisterViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.setupViewsUI()
    }
    
    func setupViewsUI() {
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.layer.masksToBounds = true
        self.registerButton.backgroundColor = UIColor(red: 168/255.0, green: 233/255.0, blue: 128/255.0, alpha: 0.8)
        
        self.cancelButton.setTitleColor(UIColor(colorHex: KDYColor.tabbarSelectedTextColor), forState: .Normal)
        
        // 修改光标颜色
        self.mailTextField.tintColor    = UIColor(colorHex: KDYColor.tabbarSelectedTextColor)
        self.accountTextField.tintColor = self.mailTextField.tintColor
        self.passwordTextFiled.tintColor = self.mailTextField.tintColor
    }

    // MARK: - Event Responses
    @IBAction func cancelButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerButtonAction(sender: AnyObject) {
        /**
         *  注册环信，并同时注册LeanClound，建立 _User表
         */
        
        let mail     = self.mailTextField.text
        let username = self.accountTextField.text
        let password = self.passwordTextFiled.text
        
        EMClient.sharedClient().registerWithUsername(username, password: password) { (account, error) in
            if error != nil {
                print("注册环信失败！error = \(error.description)")
            } else {   // 成功后，注册LeanCloud..
                print(">>> 注册环信成功 <<<")
                self.loginLeanCloud(mail!, userName: username!, password: password!)
            }
        }
    }
    
    func loginLeanCloud(mail: String, userName: String, password: String) {
        let user = AVUser()
        user.email    = mail
        user.username = userName
        user.password = password
        
        user.signUpInBackgroundWithBlock({ (succeeded, error) in
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

