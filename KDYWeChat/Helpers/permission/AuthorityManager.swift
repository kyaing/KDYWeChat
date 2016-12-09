//
//  AuthorityManager.swift
//  KDYWeChat
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import Proposer
import AVFoundation

/// 系统权限管理类
class AuthorityManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    static let shareInstance = AuthorityManager()
    fileprivate override init() {
        super.init()
    }
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        return imagePicker
    }()
    
    typealias presentControllerAction = (_ imagePicker: UIImagePickerController) -> Void
    typealias showAlertAction = (_ resource: PrivateResource) -> Void
    
    // MARK: - Public Methods
    /**
     *  选取照片
     */
    func choosePhotos(_ presentAction: @escaping presentControllerAction, alertAction: showAlertAction) {
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
    
    /**
     *  检测录音权限
     */
    func checkRecordingPermission() -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .duckOthers)
            do {
                try session.setActive(true)
                session.requestRecordPermission{ allowed in
                    if !allowed {
                        print("无法访问您的麦克风")
                    }
                }
                
                return true
                
            } catch let error as NSError {
                print("Could not activate the audio session:\(error)")
                return false
            }
            
        } catch let error as NSError {
            print("An error occurred in setting the audio ,session category. Error = \(error)")
            return false
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

