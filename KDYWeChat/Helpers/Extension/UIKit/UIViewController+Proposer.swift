//
//  UIViewController+Proposer.swift
//  KDYWeChat
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import Proposer

extension PrivateResource {

    var proposeMessage: String {
        switch self {
        case .photos:
            return NSLocalizedString("Proposer need to access your Photos to choose photo.", comment: "")
        case .camera:
            return NSLocalizedString("Proposer need to access your Camera to take photo.", comment: "")
        case .microphone:
            return NSLocalizedString("Proposer need to access your Microphone to record audio.", comment: "")
        case .contacts:
            return NSLocalizedString("Proposer need to access your Contacts to match friends.", comment: "")
        case .reminders:
            return NSLocalizedString("Proposer need to access your Reminders to create reminder.", comment: "")
        case .calendar:
            return NSLocalizedString("Proposer need to access your Calendar to create event.", comment: "")
        case .location:
            return NSLocalizedString("Proposer need to get your Location to share to your friends.", comment: "")
        default: return ""
        }
    }

    var noPermissionMessage: String {
        switch self {
        case .photos:
            return NSLocalizedString("Proposer can NOT access your Photos, but you can change it in iOS Settings.", comment: "")
        case .camera:
            return NSLocalizedString("Proposer can NOT access your Camera, but you can change it in iOS Settings.", comment: "")
        case .microphone:
            return NSLocalizedString("Proposer can NOT access your Microphone, but you can change it in iOS Settings.", comment: "")
        case .contacts:
            return NSLocalizedString("Proposer can NOT access your Contacts, but you can change it in iOS Settings.", comment: "")
        case .reminders:
            return NSLocalizedString("Proposer can NOT access your Reminders, but you can change it in iOS Settings.", comment: "")
        case .calendar:
            return NSLocalizedString("Proposer can NOT access your Calendar, but you can change it in iOS Settings.", comment: "")
        case .location:
            return NSLocalizedString("Proposer can NOT get your Location, but you can change it in iOS Settings.", comment: "")
        default: return ""
        }
    }
}

extension UIViewController {

    fileprivate func showDialogWithTitle(_ title: String, message: String, cancelTitle: String, confirmTitle: String, withCancelAction cancelAction : (() -> Void)?, confirmAction: (() -> Void)?) {

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelAction?()
            }
            alertController.addAction(cancelAction)

            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                confirmAction?()
            }
            alertController.addAction(confirmAction)

            self.present(alertController, animated: true, completion: nil)
        }

    func showProposeMessageIfNeedFor(_ resource: PrivateResource, andTryPropose propose: @escaping Propose) {

        if resource.isNotDeterminedAuthorization {
            showDialogWithTitle(NSLocalizedString("Notice", comment: ""), message: resource.proposeMessage, cancelTitle: NSLocalizedString("Not now", comment: ""), confirmTitle: NSLocalizedString("OK", comment: ""), withCancelAction: nil, confirmAction: {
                propose()
            })

        } else {
            propose()
        }
    }

    func alertNoPermissionToAccess(_ resource: PrivateResource) {

        showDialogWithTitle(NSLocalizedString("Sorry", comment: ""), message: resource.noPermissionMessage, cancelTitle: NSLocalizedString("忽略", comment: ""), confirmTitle: NSLocalizedString("去设置", comment: ""), withCancelAction: nil, confirmAction: {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
    }
}

extension UIViewController {
    
    typealias sucessClouse = () -> Void
    
    func proposerChoosePhotos(_ sucess: @escaping sucessClouse) {
        let photos: PrivateResource = .photos
        
        let propose: Propose = {
            proposeToAccess(photos, agreed: {
                print("I can access Photos. \n")
                sucess()
                
            }, rejected: {
                self.alertNoPermissionToAccess(photos)
            })
        }
        showProposeMessageIfNeedFor(photos, andTryPropose: propose)
    }
}

