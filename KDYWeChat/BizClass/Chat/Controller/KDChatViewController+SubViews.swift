//
//  KDChatViewController+SubViews.swift
//  KDYWeChat
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

// MARK: - SubViews
extension KDChatViewController {
    
    /**
     *  初始化子视图
     */
    func setupChildViews() {
        setupBottomBarView()
        setupChatTableView()
        setupEmotionKeyboard()
        setupShareKeyboard()
        setupRecordingView()
    }
    
    /**
     *  初始化底部视图
     */
    func setupBottomBarView() {
        self.bottomBarView = NSBundle.mainBundle().loadNibNamed("ChatBottomBarView", owner: nil, options: nil).last as! ChatBottomBarView
        self.bottomBarView.delegate = self   // 工具栏代理
        self.bottomBarView.inputTextView.delegate = self  // 输入框代理
        self.view.addSubview(self.bottomBarView)
        
        self.bottomBarView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(kBarViewHeight)
            
            // BarView底部的约束
            barPaddingBottomConstranit = make.bottom.equalTo(view.snp_bottom).constraint
        }
    }
    
    /**
     *  初始化表格视图
     */
    func setupChatTableView() {
        self.view.addSubview(self.chatTableView)
        
        self.chatTableView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.top.equalTo(self.view.snp_top).offset(64)  // 为什么top 要下偏移64?
            make.bottom.equalTo(self.bottomBarView.snp_top)
        }
        
        // 添加点击手势，隐藏所有键盘
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        self.chatTableView.addGestureRecognizer(tapGesture)
        tapGesture.rx_event.subscribeNext { _ in
            self.hideAllKeyboard()
        }
        .addDisposableTo(self.disposeBag)
        
        // 注册各个自定义的 Cell
        self.chatTableView.registerNib(UINib(nibName: "ChatTextTableCell", bundle: nil), forCellReuseIdentifier: "ChatTextTableCell")
        self.chatTableView.registerNib(UINib(nibName: "ChatImageTableCell", bundle: nil), forCellReuseIdentifier: "ChatImageTableCell")
        self.chatTableView.registerNib(UINib(nibName: "ChatAudioTableCell", bundle: nil), forCellReuseIdentifier: "ChatAudioTableCell")
        self.chatTableView.registerNib(UINib(nibName: "ChatLocationTableCell", bundle: nil), forCellReuseIdentifier: "ChatLocationTableCell")
        self.chatTableView.registerNib(UINib(nibName: "ChatRedEnvelopeCell", bundle: nil), forCellReuseIdentifier: "ChatRedEnvelopeCell")
        self.chatTableView.registerNib(UINib(nibName: "ChatTimeTableCell", bundle: nil), forCellReuseIdentifier: "ChatTimeTableCell")
    }
    
    /**
     *  初始化表情键盘
     */
    func setupEmotionKeyboard() {
        self.emotionView = NSBundle.mainBundle().loadNibNamed("ChatEmotionView", owner: nil, options: nil).last as! ChatEmotionView
        self.emotionView.delegate = self
        self.view.addSubview(self.emotionView)
        
        self.emotionView.snp_makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.view.snp_left)
            make.right.equalTo(strongSelf.view.snp_right)
            make.top.equalTo(strongSelf.bottomBarView.snp_bottom)
            make.height.equalTo(kCustomKeyboardHeight)
        }
    }
    
    /**
     *  初始化扩展键盘
     */
    func setupShareKeyboard() {
        self.shareView = NSBundle.mainBundle().loadNibNamed("ChatShareMoreView", owner: nil, options: nil).last as! ChatShareMoreView
        self.shareView.delegate = self
        self.view.addSubview(self.shareView)
        
        self.shareView.snp_makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.bottomBarView.snp_bottom)
            make.height.equalTo(kCustomKeyboardHeight)
        }
    }
    
    /**
     *  初始化录音视图
     */
    func setupRecordingView() {
        self.recordingView = NSBundle.mainBundle().loadNibNamed("ChatRecordingView", owner: nil, options: nil).last as! ChatRecordingView
        self.recordingView.hidden = true
        self.view.addSubview(self.recordingView)
        
        self.recordingView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize(width: 300, height: 300))
        }
    }
}

