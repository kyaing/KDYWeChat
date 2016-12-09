//
//  PHAssets+UIImage.swift
//  KDYWeChat
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    
    /**
     *  从Asset 中获取UIImage图片
     *  参考：https://objccn.io/issue-21-4/
     */
    func getUIImage() -> UIImage? {
        var image: UIImage?
        let manager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true  // 是否同步加载
        options.isNetworkAccessAllowed = true  // 是否允许从 iCloud加载图片
        options.resizeMode = .exact 
     
        manager.requestImage(
            for: self,
            targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
            contentMode: .aspectFill,
            options: options) { (retImage, info) in
                if let returnImage = retImage {
                    image = returnImage
                } else {
                    image = nil
                }
            }
        
        return image
    }
}

