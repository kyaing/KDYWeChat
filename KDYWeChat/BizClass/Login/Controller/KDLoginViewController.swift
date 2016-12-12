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
        
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = .default
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // 初始化UI
        setupViewsUI()
        
        viewModel = LoginViewModel(input:
                (username: accountTextFiled.rx.text.asDriver(),
                 password: passwordTextField.rx.text.asDriver()))
        
        viewModel.loginBtnEnabled
            .drive { [weak self] (valid) in
                self?.loginButton.backgroundColor
                    = valid ? UIColor(colorHex: .chatGreenColor) : UIColor(colorHex: .chatLightGreenColor)
                self?.loginButton.enabled = valid ? true : false
            }
            .addDisposableTo(disposeBag)
    }
    
    func setupViewsUI() {
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor(colorHex: .separatorColor).cgColor
        loginButton.layer.borderWidth = 0.5
        loginButton.backgroundColor = UIColor(colorHex: .chatLightGreenColor)
        
        // 修改光标颜色
        accountTextFiled.tintColor  = UIColor(colorHex: .tabbarSelectedTextColor)
        passwordTextField.tintColor = UIColor(colorHex: .tabbarSelectedTextColor)
    }
    
    // MARK: - Event Responses
    @IBAction func loginButtonAction(_ sender: AnyObject) {
        
        var userName = accountTextFiled.text
        let password = passwordTextField.text
    
        MBProgressHUD.showAdded(to: self.view, animated: true)
        AVUser.logInWithUsername(inBackground: userName, password: password) { (user, error) in
        
            if error != nil {
                print("error = \(error?.localizedDescription)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
            } else {
                print(">>> 登录成功 <<<")
                
                // 从LeanCloud中取出对应的环信用户名
                userName = AVUser.current().username
                EMClient.shared().login(withUsername: userName, password: password) { (name, error) in
                
                    if (error != nil) {
                        var codeString = ""
                        switch error?.code {
                        case EMErrorNetworkUnavailable: codeString = "网络不可用"
                        case EMErrorServerNotReachable: codeString = "服务器未连接"
                        case EMErrorUserAuthenticationFailed: codeString = "密码验证错误"
                        default: codeString = "环信登录失败"
                        }
                        print("\(codeString)")
                        
                    } else {
                        print(">> 环信登录成功 <<")
                        
                        // 设置自动登录
                        EMClient.shared().options.isAutoLogin = true
                        
                        DispatchQueue.main.async {
                            KDYWeChatHelper.shareInstance.asyncPushOptions()
                            KDYWeChatHelper.shareInstance.asyncConversationFromDB()
                            
                            // 发送自动登录的通知
                            self.postNotificationName(kLoginStateChangedNoti, object: NSNumber(value: EMClient.shared().isLoggedIn as Bool))
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func moreButtonAction(_ sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let changeAction = UIAlertAction(title: "切换账号", style: .default) { alertAction in
        }
        
        let registerAction = UIAlertAction(title: "注册", style: .default) { alertAction in
            let registerController = KDRegisterViewController.initFromNib()
            self.navigationController?.present(registerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        /**
         *  修改显示的字体颜色 
         *  (仍然没有找到如何改变字体大小的方法！)
         */
        changeAction.setValue(UIColor(colorHex: "#2a2a2a")!, forKey: "_titleTextColor")
        registerAction.setValue(UIColor(colorHex: "#2a2a2a")!, forKey: "_titleTextColor")
        cancelAction.setValue(UIColor(colorHex: "#7d7d7d")!, forKey: "_titleTextColor")
        
        alertController.addAction(changeAction)
        alertController.addAction(registerAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        accountTextFiled.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

