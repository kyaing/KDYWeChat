//
//  AuthorityManager.swift
//  KDYWeChat
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Proposer

/// 系统权限管理类
class AuthorityManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    static let shareInstance = AuthorityManager()
    private override init() {
        super.init()
    }
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        return imagePicker
    }()
    
    typealias presentControllerAction = (imagePicker: UIImagePickerController) -> Void
    typealias showAlertAction = (resource: PrivateResource) -> Void
    
    // MARK: - Public Methods
    /**
     *  选取照片
     */
    func choosePhotos(presentAction: presentControllerAction, alertAction: showAlertAction) {
        let photos: PrivateResource = .Photos
        
        proposeToAccess(photos, agreed: {
            print("成功选取 photos")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                self.imagePicker.sourceType = .PhotoLibrary
                self.imagePicker.allowsEditing = true
                
                presentAction(imagePicker: self.imagePicker)
            }
        }) {
            alertAction(resource: photos)
        }
    }
    
    /**
     *  拍摄照片
     */
    func takePhotos() {
        let camera: PrivateResource = .Camera
        
        proposeToAccess(camera, agreed: { 
            print("成功拍取 photos")
            
        }) {
        
        }
    }
    
    /**
     *  获取通讯录
     */
    func readContacts() {
        
    }
    
    /**
     *  获取定位
     */
    func getLocations() {
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // 上传用户头像
        UserInfoManager.shareInstance.uploadUserAvatorInBackground(image, success: { (success) in
            
        }) { (error) in
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

