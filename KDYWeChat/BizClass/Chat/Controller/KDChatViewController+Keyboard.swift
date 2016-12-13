//
//  TSChatViewController+Keyboard.swift
//  TSWeChat
//
//  Created by Hilen on 12/18/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation

/**
 * 所有的键盘动画都是控制 chatBarView 的 bottomConstraint。
 * 表情键盘和分享键盘的约束都是依赖 chatBarView
 */

// MARK: - Keyboard
extension KDChatViewController {
    
    /**
     *  键盘控制
     */
    func keyboardControl() {
        let notificationCenter = NotificationCenter.default
        
        // 系统键盘显示的通知
        notificationCenter.addObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillShow.rawValue,
            object: nil) { (observer, notification) in
                self.chatTableView.scrollToBottom(false)
                self.keyboardControling(notification, isShowkeyboard: true)
            }
        
        notificationCenter.addObserver(
            self,
            name: NSNotification.Name.UIKeyboardDidShow.rawValue,
            object: nil) { (observer, notification) in
                if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                    _ = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                }
            }
        
        // 系统键盘隐藏的通知
        notificationCenter.addObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillHide.rawValue,
            object: nil) { (observer, notification) in
                self.chatTableView.scrollToBottom(true)
                self.keyboardControling(notification, isShowkeyboard: false)
            }
        
        notificationCenter.addObserver(
            self,
            name: NSNotification.Name.UIKeyboardDidHide.rawValue,
            object: nil) { (observer, notification) in
                
            }
    }
    
    /**
     键盘控制
     
     - parameter notification:   通知对象
     - parameter isShowkeyboard: 是否显示键盘
     */
    func keyboardControling(_ notification: Notification, isShowkeyboard: Bool) {
        /*
         如果是表情键盘或者 分享键盘 ，响应自己 delegate 的处理键盘事件。
         
         因为：当点击唤起自定义键盘时，操作栏的输入框需要 resignFirstResponder，这时候会给键盘发送通知。
         通知中需要对 actionbar frame 进行重置位置计算, 在 delegate 回调中进行计算。所以在这里进行拦截。
         Button 的点击方法中已经处理了 delegate。
         */
        
        let keyboardType = bottomBarView.keyboardType
        if keyboardType == .emotion || keyboardType == .share {
            return
        }
        
        self.keyboardNoti = notification
        
        // 处理系统键盘 .Default, .Text
        var userInfo       = (notification as NSNotification).userInfo!
        let keyboardRect   = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve          = ((userInfo[UIKeyboardAnimationCurveUserInfoKey]!) as AnyObject).int8Value  // curve值：7
        let duration       = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset   = self.view.bounds.size.height - convertedFrame.origin.y
        // let options     = UIViewAnimationOptions(rawValue: UInt(curve) << 16 | UIViewAnimationOptions.BeginFromCurrentState.rawValue)
        
        self.chatTableView.stopScrolling()
        self.barPaddingBottomConstranit?.update(offset: -heightOffset)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration!)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve!))!)
        self.view.layoutIfNeeded()
        if isShowkeyboard {
            self.chatTableView.scrollToBottom(false)
        }
        UIView.commitAnimations()
    }
    
    /**
     *  当唤起自定义键盘时，此时点击语音按钮，需要隐藏全部自定义键盘
     */
    func hideCustomKeyboard() {
        let heightOffset: CGFloat = 0
        barPaddingBottomConstranit?.update(offset: heightOffset)
        
        // 同时要恢复表情按钮图标
        self.bottomBarView.emotionButton.emotionButtonChangeToKeyboardUI(false)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.25)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
        self.view.layoutIfNeeded()
        self.chatTableView.scrollToBottom(false)
        UIView.commitAnimations()
    }
    
    /**
     *  隐藏所有的键盘
     */
    func hideAllKeyboard() {
        hideCustomKeyboard()
        self.bottomBarView.resignKeyboardInput()
    }
}

