//
//  UIViewController+Proposer.swift
//  KDYWeChat
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import Proposer
import AddressBook
import Contacts

extension PrivateResource {

    var proposeMessage: String {
        switch self {
        case .photos:
            return "App需要访问你手机相册来选择照片。"
        case .camera:
            return "App需要访问你手机相机来拍摄照片。"
        case .microphone:
            return "App需要访问你手机麦克风来选择录音。"
        case .contacts:
            return "App需要访问你手机通讯录来匹配好友。"
        case .reminders:
            return "App需要访问你手机提醒事项来创建提醒事项。"
        case .calendar:
            return "App需要访问你手机日历来创建事件。"
        case .location:
            return "App需要访问你手机定位服务来与服务分享。"
        default: return ""
        }
    }

    var noPermissionMessage: String {
        switch self {
        case .photos:
            return "请在iPhone的设置选项中，允许App访问你的手机相册。"
        case .camera:
            return "请在iPhone的设置选项中，允许App访问你的手机相机。"
        case .microphone:
            return "请在iPhone的设置选项中，允许App访问你的手机麦克风。"
        case .contacts:
            return "请在iPhone的设置选项中，允许App访问你的手机通讯录。"
        case .reminders:
            return "请在iPhone的设置选项中，允许App访问你的手机提醒事项。"
        case .calendar:
            return "请在iPhone的设置选项中，允许App访问你的手机日历。"
        case .location:
            return "请在iPhone的设置选项中，允许App访问你的手机定位服务。"
        default:
            return ""
        }
    }
}

extension UIViewController {

    fileprivate func showDialogWithTitle(_ title: String, message: String, cancelTitle: String, confirmTitle: String, withCancelAction cancelAction : (() -> Void)?, confirmAction: (() -> Void)?) {

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelAction?()
            }

            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                confirmAction?()
            }

            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)

            self.present(alertController, animated: true, completion: nil)
        }

    func showProposeMessageIfNeedFor(_ resource: PrivateResource, andTryPropose propose: @escaping Propose) {

        if resource.isNotDeterminedAuthorization {
            showDialogWithTitle("注意",
                                message: resource.proposeMessage,
                                cancelTitle: "忽略",
                                confirmTitle: "好的",
                                withCancelAction: nil,
                                confirmAction: {
                propose()
            })

        } else {
            propose()
        }
    }

    func alertNoPermissionToAccess(_ resource: PrivateResource) {

        showDialogWithTitle("提示",
                            message: resource.noPermissionMessage,
                            cancelTitle: "忽略",
                            confirmTitle: "去设置",
                            withCancelAction: nil,
                            confirmAction: {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
    }
}

extension UIViewController {

    typealias sucessClouse = () -> Void

    /**
     *  选择图库权限
     */
    func proposerChoosePhotos(_ sucess: @escaping sucessClouse) {
        let photos: PrivateResource = .photos
        let propose: Propose = {
            proposeToAccess(photos, agreed: {
                print("I can access Photos. \n")

                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .savedPhotosAlbum

                    sucess()
                }

            }, rejected: {
                self.alertNoPermissionToAccess(photos)
            })
        }
        showProposeMessageIfNeedFor(photos, andTryPropose: propose)
    }

    /**
     *  拍摄照片权限
     */
    func proposerTakePhotos() {
        let camera: PrivateResource = .camera
        let propose: Propose = {
            proposeToAccess(camera, agreed: {
                print("I can access Camera. \n")

                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }, rejected: {
                self.alertNoPermissionToAccess(camera)
            })
        }
        showProposeMessageIfNeedFor(camera, andTryPropose: propose)
    }

    /**
     *  语音输入权限
     */
    func proposeRecordAudio() {
        let microphone: PrivateResource = .microphone
        let propose: Propose = {
            proposeToAccess(microphone, agreed: {
                print("I can access Microphone. \n")

            }, rejected: {
                self.alertNoPermissionToAccess(microphone)
            })
        }
        showProposeMessageIfNeedFor(microphone, andTryPropose: propose)
    }

    /**
     *  读通讯录权限
     */
    func proposeReadContacts(_ sucess: @escaping sucessClouse) {
        let contacts: PrivateResource = .contacts
        let propose: Propose = {
            proposeToAccess(contacts, agreed: {
                print("I can access Contacts. \n")
                sucess()

            }, rejected: {
                self.alertNoPermissionToAccess(contacts)
            })
        }
        showProposeMessageIfNeedFor(contacts, andTryPropose: propose)
    }

    /**
     *  定位位置权限
     */
    func proposeShareLocation(_ sucess: @escaping sucessClouse) {

        let location: PrivateResource = .location(.whenInUse)
        let propose: Propose = {
            proposeToAccess(location, agreed: {
                print("I can access Location. \n")
                sucess()

            }, rejected: {
                self.alertNoPermissionToAccess(location)
            })
        }

        showProposeMessageIfNeedFor(location, andTryPropose: propose)
    }

    /**
     *  发送通知权限
     */
    func proposeSendNotification() {

    }

    func readingAllContacts() {

        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
            
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            
            do {
                try store.enumerateContacts(with: request, usingBlock: {(contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    // 获取姓名
                    let lastName = contact.familyName
                    let firstName = contact.givenName
                    print("姓名: \(lastName)\(firstName)")
                    
                    // 获取电话号码
                    let phoneNumbers = contact.phoneNumbers
                    for phoneNumber in phoneNumbers {
                        print(phoneNumber.label ?? "")
                        print(phoneNumber.value.stringValue)
                    }
                })
            } catch {
                print(error)
            }
            
        } else {
            // iOS8.0之前
            // 使用 AddressBook，访问通讯录
        }
    }
}

