//
//  ChatShareMoreView.swift
//  KDYWeChat
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 聊天扩展视图
class ChatShareMoreView: UIView {
    
    @IBOutlet weak var shareCollectionView: UICollectionView!
    
    // 数据源 (存储着元组单元)
    var itemDataSource: [(name: String, image: String)] = [
        ("照片",   "sharemore_pic"),
        ("拍摄",   "sharemore_video"),
        ("小视频", "sharemore_sight"),
        ("语音聊天", "sharemore_voiceinput"),
        ("视频聊天", "sharemore_videovoip"),
        ("红包", "sharemore_wallet"),
        ("位置", "sharemore_location"),
        ("收藏", "sharemore_myfav")
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.shareCollectionView.delegate = self
        self.shareCollectionView.dataSource = self
        self.shareCollectionView.backgroundColor = UIColor.whiteColor()
        
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = (UIScreen.width - 5 * 15 ) / 4.0
        flowLayout.itemSize = CGSizeMake(itemWidth, 90)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15)
        
        self.shareCollectionView.collectionViewLayout = flowLayout        
        self.shareCollectionView.registerNib(UINib(nibName: "ChatShareCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ChatShareCollectionCell")
    }
}

// MARK: - UICollectionViewDataSource
extension ChatShareMoreView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let object = self.itemDataSource[indexPath.row]
        
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("ChatShareCollectionCell", forIndexPath: indexPath) as! ChatShareCollectionCell
        collectionCell.shareButton.setImage(UIImage(named: object.image), forState: .Normal)
        collectionCell.shareLabel.text = object.name
        
        return collectionCell
    }
}

// MARK: - UICollectionViewDelegate
extension ChatShareMoreView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        print("click index = \(indexPath.row)")
    }
}

