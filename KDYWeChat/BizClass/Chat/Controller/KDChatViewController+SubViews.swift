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
        
        setupBgImageView()
        setupBottomBarView()
        setupChatTableView()
        setupEmotionKeyboard()
        setupShareKeyboard()
        setupRecordingView()
    }
    
    /**
     *  初始化聊天图片
     */
    func setupBgImageView() {
        self.bgImageView = UIImageView()
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.clipsToBounds = true
        self.view.addSubview(self.bgImageView)
        
        self.bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    /**
     *  初始化底部视图
     */
    func setupBottomBarView() {
        self.bottomBarView = ChatBottomBarView.loadFromNib()
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
            make.top.equalTo(self.view.snp_top).offset(64)  
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
        self.chatTableView.registerReusableCell(ChatTextTableCell)     // 文本 cell
        self.chatTableView.registerReusableCell(ChatImageTableCell)    // 图片 cell
        self.chatTableView.registerReusableCell(ChatAudioTableCell)    // 语音 cell
        self.chatTableView.registerReusableCell(ChatLocationTableCell) // 位置 cell
        self.chatTableView.registerReusableCell(ChatRedEnvelopeCell)   // 红包 cell
        self.chatTableView.registerReusableCell(ChatTimeTableCell)     // 时间 cell
    }
    
    /**
     *  初始化表情键盘
     */
    func setupEmotionKeyboard() {
        self.emotionView = ChatEmotionView.loadFromNib()
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
        self.shareView = ChatShareMoreView.loadFromNib()
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
        self.recordingView = ChatRecordingView.loadFromNib()
        self.recordingView.isHidden = true
        self.view.addSubview(self.recordingView)
        
        self.recordingView.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize(width: 300, height: 300))
        }
    }
}

