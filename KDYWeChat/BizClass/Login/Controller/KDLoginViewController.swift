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
        
        // 隐藏导航栏
        self.navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // 初始化UI
        setupViewsUI()
        
        self.viewModel
            = LoginViewModel(input: (username: self.accountTextFiled.rx_text.asDriver(),
                password: self.passwordTextField.rx_text.asDriver()))
        
        self.viewModel.loginBtnEnabled
            .driveNext { [weak self] (valid) in
                self?.loginButton.backgroundColor
                    = valid ? UIColor(colorHex: .chatGreenColor) : UIColor(colorHex: .chatLightGreenColor)
                self?.loginButton.enabled = valid ? true : false
            }
            .addDisposableTo(self.disposeBag)
    }
    
    func setupViewsUI() {
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.layer.borderColor = UIColor(colorHex: .separatorColor).CGColor
        self.loginButton.layer.borderWidth = 0.5
        self.loginButton.backgroundColor = UIColor(colorHex: .chatLightGreenColor)
        
        // 修改光标颜色
        self.accountTextFiled.tintColor  = UIColor(colorHex: .tabbarSelectedTextColor)
        self.passwordTextField.tintColor = UIColor(colorHex: .tabbarSelectedTextColor)
    }
    
    // for test
    func getNumber() -> Int {
        return 100
    }
    
    // MARK: - Event Responses
    @IBAction func loginButtonAction(sender: AnyObject) {
        
        var userName = self.accountTextFiled.text
        let password = self.passwordTextField.text
        
        LoadingHUDShow.shareInstance.showHUDWithText("登录中...", toView: self.view)
        AVUser.logInWithUsernameInBackground(userName, password: password) { (user, error) in
            
            LoadingHUDShow.shareInstance.hideHUD(self.view)
            if error != nil {
                print("error = \(error.localizedDescription)")
                
            } else {
                print(">>> 登录成功 <<<")
                
                // 从LeanCloud中取出对应的环信用户名
                userName = AVUser.currentUser().username
                self.loginEaseSDK(userName!, password: password!)
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
        self.accountTextFiled.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    // MARK: - Private Methods
    func loginEaseSDK(userName: String, password: String) {
        EMClient.sharedClient().loginWithUsername(userName, password: password) { (name, error) in
            if (error != nil) {
                switch error.code {
                case EMErrorNetworkUnavailable: print("网络不可用")
                case EMErrorServerNotReachable: print("服务器未连接")
                case EMErrorUserAuthenticationFailed: print("密码验证错误")
                default: print(">> 环信登录失败 <<")
                }
                
            } else {
                print(">> 环信登录成功 <<")
                
                // 设置自动登录
                EMClient.sharedClient().options.isAutoLogin = true
                
                dispatch_async(dispatch_get_main_queue(), { 
                    KDYWeChatHelper.shareInstance.asyncPushOptions()
                    KDYWeChatHelper.shareInstance.asyncConversationFromDB()
                    
                    // 发送自动登录的通知
                    NSNotificationCenter.defaultCenter().postNotificationName(kLoginStateChangedNoti, object: NSNumber(bool: EMClient.sharedClient().isLoggedIn))
                })
            }
        }
    }
}

