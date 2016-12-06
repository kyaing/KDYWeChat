//
//  KDLoginViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import AVOSCloud
import RxSwift
import RxCocoa
import MBProgressHUD

/// 登录页面
final class KDLoginViewController: UIViewController {
    
    // MARK: - Parameters
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var accountTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let disposeBag = DisposeBag()
    
    var viewModel: LoginViewModel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // 初始化UI
        setupViewsUI()
        
        viewModel = LoginViewModel(input:
                (username: accountTextFiled.rx_text.asDriver(),
                 password: passwordTextField.rx_text.asDriver()))
        
        viewModel.loginBtnEnabled
            .driveNext { [weak self] (valid) in
                self?.loginButton.backgroundColor
                    = valid ? UIColor(colorHex: .chatGreenColor) : UIColor(colorHex: .chatLightGreenColor)
                self?.loginButton.enabled = valid ? true : false
            }
            .addDisposableTo(disposeBag)
    }
    
    func setupViewsUI() {
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor(colorHex: .separatorColor).CGColor
        loginButton.layer.borderWidth = 0.5
        loginButton.backgroundColor = UIColor(colorHex: .chatLightGreenColor)
        
        // 修改光标颜色
        accountTextFiled.tintColor  = UIColor(colorHex: .tabbarSelectedTextColor)
        passwordTextField.tintColor = UIColor(colorHex: .tabbarSelectedTextColor)
    }
    
    // MARK: - Event Responses
    @IBAction func loginButtonAction(sender: AnyObject) {
        
        var userName = accountTextFiled.text
        let password = passwordTextField.text
    
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        AVUser.logInWithUsernameInBackground(userName, password: password) { (user, error) in
        
            if error != nil {
                print("error = \(error.localizedDescription)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            } else {
                print(">>> 登录成功 <<<")
                
                // 从LeanCloud中取出对应的环信用户名
                userName = AVUser.currentUser().username
                EMClient.sharedClient().loginWithUsername(userName, password: password) { (name, error) in
                
                    if (error != nil) {
                        var codeString = ""
                        switch error.code {
                        case EMErrorNetworkUnavailable: codeString = "网络不可用"
                        case EMErrorServerNotReachable: codeString = "服务器未连接"
                        case EMErrorUserAuthenticationFailed: codeString = "密码验证错误"
                        default: codeString = "环信登录失败"
                        }
                        print("\(codeString)")
                        
                    } else {
                        print(">> 环信登录成功 <<")
                        
                        // 设置自动登录
                        EMClient.sharedClient().options.isAutoLogin = true
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            KDYWeChatHelper.shareInstance.asyncPushOptions()
                            KDYWeChatHelper.shareInstance.asyncConversationFromDB()
                            
                            // 发送自动登录的通知
                            self.postNotificationName(kLoginStateChangedNoti, object: NSNumber(bool: EMClient.sharedClient().isLoggedIn))
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func moreButtonAction(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

        let changeAction = UIAlertAction(title: "切换账号", style: .Default) { alertAction in
        }
        
        let registerAction = UIAlertAction(title: "注册", style: .Default) { alertAction in
            let registerController = KDRegisterViewController.initFromNib()
            self.navigationController?.presentViewController(registerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        /**
         *  修改显示的字体颜色 
         *  (仍然没有找到如何改变字体大小的方法！)
         */
        changeAction.setValue(UIColor(rgba: "#2a2a2a"), forKey: "_titleTextColor")
        registerAction.setValue(UIColor(rgba: "#2a2a2a"), forKey: "_titleTextColor")
        cancelAction.setValue(UIColor(rgba: "#7d7d7d"), forKey: "_titleTextColor")
        
        alertController.addAction(changeAction)
        alertController.addAction(registerAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        accountTextFiled.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

