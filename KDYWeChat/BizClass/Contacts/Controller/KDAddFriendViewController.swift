//
//  KDAddFriendViewController.swift
//  KDYWeChat
//
//  Created by mac on 16/10/20.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import RxSwift

/// 添加好友页面
class KDAddFriendViewController: UIViewController {

    // MARK: - Parameters
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendTableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加好友"
    }
}

