//
//  BSImagePicker.swift
//  KDYWeChat
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import Photos
import BSImagePicker
import Proposer

extension UIViewController {
    
    /**
     *  封装BSImagePicker 图片选择器
     */
    func ky_presentImagePickerController(_ maxNumberOfSelections: Int,
                                         select: ((_ asset: PHAsset) -> Void)?,
                                         deselect: ((_ asset: PHAsset) -> Void)?,
                                         cancel: (([PHAsset]) -> Void)?,
                                         finish: (([PHAsset]) -> Void)?,
                                         completion: (() -> Void)?) {

        let imagePicker = BSImagePickerViewController()
        imagePicker.maxNumberOfSelections = maxNumberOfSelections
        
        // 图片权限
        proposerChoosePhotos {
            // 选择图片
            self.bs_presentImagePickerController(imagePicker, animated: true, select: select, deselect: deselect, cancel: cancel, finish: finish, completion: {
                if let newCompletion = completion {
                    newCompletion()
                }
            })
        }
    }
}

