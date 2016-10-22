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
    
    func setupChildViews() {
        setupBottomBarView()
        setupChatTableView()
        setupEmotionKeyboard()
        setupShareKeyboard()
    }
    
    /**
     *  初始化底部视图
     */
    func setupBottomBarView() {
        self.bottomBarView = NSBundle.mainBundle().loadNibNamed("ChatBottomBarView", owner: nil, options: nil).last as! ChatBottomBarView
        self.bottomBarView.delegate = self
        self.bottomBarView.inputTextView.delegate = self
        view.addSubview(self.bottomBarView)
        
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
        view.addSubview(self.chatTableView)
        
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
        
        // 注册Cell
        self.chatTableView.registerNib(UINib.init(nibName: "ChatTextTableCell", bundle: nil), forCellReuseIdentifier: "ChatTextTableCell")
        self.chatTableView.registerNib(UINib.init(nibName: "ChatImageTableCell", bundle: nil), forCellReuseIdentifier: "ChatImageTableCell")
        self.chatTableView.registerNib(UINib.init(nibName: "ChatAudioTableCell", bundle: nil), forCellReuseIdentifier: "ChatAudioTableCell")
        self.chatTableView.registerNib(UINib.init(nibName: "ChatLocationTableCell", bundle: nil), forCellReuseIdentifier: "ChatLocationTableCell")
        self.chatTableView.registerNib(UINib.init(nibName: "ChatRedEnvelopeCell", bundle: nil), forCellReuseIdentifier: "ChatRedEnvelopeCell")
        self.chatTableView.registerNib(UINib.init(nibName: "ChatTimeTableCell", bundle: nil), forCellReuseIdentifier: "ChatTimeTableCell")
    }
    
    /**
     *  初始化表情键盘
     */
    func setupEmotionKeyboard() {
        self.emotionView = NSBundle.mainBundle().loadNibNamed("ChatEmotionView", owner: nil, options: nil).last as! ChatEmotionView
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
        view.addSubview(self.shareView)
        
        self.shareView.snp_makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.bottomBarView.snp_bottom)
            make.height.equalTo(kCustomKeyboardHeight)
        }
    }
}

